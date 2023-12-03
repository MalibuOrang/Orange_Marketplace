import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/services/delete_button_function.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/widgets/delete_button.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../controllers/home_controller.dart';
import '../../../widgets/normal_text.dart';
import 'chat_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class MessagesScreenSeller extends StatelessWidget {
  const MessagesScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: darkGrey,
          onPressed: () {
            Get.back();
          },
        ),
        title: boldText(text: messages, size: 16.0, color: fontGrey),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(color: purpleColor);
          } else if (snapshot.data!.docs.isEmpty) {
            return "No messages yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(data.length, (index) {
                    var t = data[index]['created_on'] == null
                        ? DateTime.now()
                        : data[index]['created_on'].toDate();
                    var time = intl.DateFormat("h:mma").format(t);
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(() => const ChatScreenSeller(), arguments: [
                            data[index]['sender_name'],
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
                          backgroundColor: purpleColor,
                          child: Icon(
                            Icons.person,
                            color: whiteColor,
                          ),
                        ),
                        title: SizedBox(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                              StreamBuilder(
                                stream: HomeController()
                                    .getUserStatusOnlineStream(
                                        userCollection,
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
                                      color: Colors.orange,
                                      size: 15,
                                    );
                                  } else {
                                    return snapshot.data == true
                                        ? const Icon(
                                            Icons.radio_button_checked,
                                            color: Colors.purple,
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
                              "${data[index]['sender_name']} "
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .make(),
                              normalText(text: time, color: darkGrey),
                            ])),
                        subtitle: normalText(
                            text: "${data[index]['last_msg']}",
                            color: darkGrey),
                        trailing: deleteButtons(onPress: () {
                          DeleteFuctinoButton().onPressDeleteBut(context, data,
                              deleting:
                                  FirestoreServices.deleteChat(data[index].id),
                              question: "Delete chat with this user?");
                        }),
                      ),
                    );
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
