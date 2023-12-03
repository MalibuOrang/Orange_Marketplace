import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/services/push_notification_services.dart';

class ChatsController extends GetxController {
  ScrollController scrollMessageControllerByer = ScrollController();
  ScrollController scrollMessageControllerSeller = ScrollController();
  var chats = firestore.collection(chatCollection);
  String? friendName = Get.arguments[0];
  var friendId = Get.arguments[1];
  var currentName = username;
  var currentToken = userToken;
  var currentId = currentUser!.uid;
  var msgControllerByer = TextEditingController();
  var msgControllerSeller = TextEditingController();
  var isLoading = false.obs;
  var currentChatDocId = "".obs;
  int? index = Get.arguments[2];
  String? frendToken = Get.arguments[3];
  @override
  void onInit() async {
    await getChatId();
    super.onInit();
  }

  readChatMessage() async {
    QuerySnapshot querySnapshot = await chats
        .doc(currentChatDocId.value)
        .collection(messagesCollection)
        .where('uid', isNotEqualTo: currentUser!.uid)
        .get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await chats
          .doc(currentChatDocId.value)
          .collection(messagesCollection)
          .doc(doc.id)
          .update({
        'msg_read': true,
      });
    }
  }

  void chatMessageScrool(ScrollController controller) {
    controller.animateTo(controller.position.maxScrollExtent,
        duration: const Duration(microseconds: 300), curve: Curves.bounceOut);
  }

  getChatId() async {
    isLoading(true);

    var snapshot = index == null
        ? await chats.where('users', isEqualTo: [friendId, currentId]).get()
        : await chats
            .where('users', arrayContainsAny: [friendId, currentId]).get();

    if (snapshot.docs.isNotEmpty) {
      if (index == null) {
        currentChatDocId.value = snapshot.docs.first.id;
      } else {
        currentChatDocId.value = snapshot.docs[index!].id;
      }
    } else {
      var newChat = await chats.add({
        'created_on': null,
        'last_msg': '',
        'users': [
          friendId,
          currentId,
        ],
        'toId': '',
        'fromId': '',
        'toToken': '',
        'fromToken': '',
        'friend_name': friendName,
        'sender_name': currentName,
      });
      currentChatDocId.value = newChat.id;
    }

    isLoading(false);
  }

  sendMsg(String msg, String? token, String typeNotification) async {
    if (msg.trim().isNotEmpty) {
      await chats.doc(currentChatDocId.value).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': currentId,
        'toToken': frendToken,
        'fromToken': currentToken,
      });
      await chats
          .doc(currentChatDocId.value)
          .collection(messagesCollection)
          .doc()
          .set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'msg_read': false,
        'uid': currentId,
      }).then((value) => PushNotificationServices.sendPushNotification(
              token, currentName!, msg, currentUser!.uid, typeNotification));
    }
  }

  onPressSendMsgBut(context) async {
    if (msgControllerByer.text.isNotEmptyAndNotNull) {
      await sendMsg(msgControllerByer.text, frendToken, "byer");
      msgControllerByer.clear();
      chatMessageScrool(scrollMessageControllerByer);
    } else {
      VxToast.show(context, msg: "Your message is empty!");
    }
  }
}
