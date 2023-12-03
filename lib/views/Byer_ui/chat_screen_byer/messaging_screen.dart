import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/home_controller.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/services/delete_button_function.dart';
import 'package:orange_marketplace/views/Byer_ui/chat_screen_byer/chat_screen.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../widgets/delete_button.dart';

import '../../../widgets/normal_text.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class MessagesScreenByer extends StatelessWidget {
  const MessagesScreenByer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "My Messages".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else if (snapshot.data!.docs.isEmpty) {
            return "No messages yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) {
                      var t = data[index]['created_on'] == null
                          ? DateTime.now()
                          : data[index]['created_on'].toDate();
                      var time = intl.DateFormat("h:mma").format(t);
                      return Card(
                        child: ListTile(
                          onTap: () async {
                            Get.to(() => const ChatScreenByer(), arguments: [
                              data[index]['friend_name'],
                              data[index]['fromId'] == currentUser!.uid
                                  ? data[index]['toId']
                                  : data[index]['fromId'],
                              index,
                              data[index]['fromId'] == currentUser!.uid
                                  ? data[index]['toToken']
                                  : data[index]['fromToken'],
                            ]);
                          },
                          leading: const CircleAvatar(
                            backgroundColor: orangeColor,
                            child: Icon(
                              Icons.person,
                              color: whiteColor,
                            ),
                          ),
                          title: SizedBox(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                StreamBuilder(
                                  stream: HomeController()
                                      .getUserStatusOnlineStream(
                                          vendorCollection,
                                          data[index]['fromId'] ==
                                                  currentUser!.uid
                                              ? data[index]['toId']
                                              : data[index]['fromId'],
                                          "status_online",
                                          context),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 15,
                                      );
                                    } else {
                                      return snapshot.data == true
                                          ? const Icon(
                                              Icons.radio_button_checked,
                                              color: Colors.green,
                                              size: 15,
                                            )
                                          : const Icon(
                                              Icons.radio_button_off,
                                              color: Colors.grey,
                                              size: 15,
                                            );
                                    }
                                  },
                                ),
                                "${data[index]['friend_name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                20.widthBox,
                                normalText(text: time, color: darkGrey),
                              ])),
                          subtitle: "${data[index]['last_msg']}".text.make(),
                          trailing: deleteButtons(onPress: () {
                            DeleteFuctinoButton().onPressDeleteBut(
                                context, data,
                                deleting: FirestoreServices.deleteChat(
                                    data[index].id),
                                question: "Delete chat with this user?");
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
