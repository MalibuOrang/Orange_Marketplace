import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/chat_controller.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/views/Byer_ui/chat_screen_byer/components/sender_bubble.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';

class ChatScreenByer extends StatefulWidget {
  const ChatScreenByer({super.key});

  @override
  State<ChatScreenByer> createState() => _ChatScreenByerState();
}

class _ChatScreenByerState extends State<ChatScreenByer> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: '${controller.friendName}'
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: loadingIndicator(),
                    )
                  : Expanded(
                      child: StreamBuilder(
                          stream: FirestoreServices.getChatMessages(
                              controller.currentChatDocId.value.toString()),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: loadingIndicator(),
                              );
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: "Send a message..."
                                    .text
                                    .color(darkFontGrey)
                                    .make(),
                              );
                            } else {
                              return ListView(
                                  controller:
                                      controller.scrollMessageControllerByer,
                                  children: snapshot.data!.docs
                                      .mapIndexed((currentValue, index) {
                                    var data = snapshot.data!.docs[index];
                                    controller.readChatMessage();
                                    return senderBubble(context, data,
                                        controller.currentChatDocId.value,
                                        messageId: data.id);
                                  }).toList());
                            }
                          }),
                    ),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller.msgControllerByer,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: textfieldGrey,
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: textfieldGrey,
                    )),
                    hintText: "Type a message...",
                  ),
                )),
                IconButton(
                  onPressed: () async {
                    await controller.onPressSendMsgBut(context);
                  },
                  icon: const Icon(
                    Icons.send,
                    color: orangeColor,
                  ),
                )
              ],
            )
                .box
                .height(80)
                .padding(const EdgeInsets.all(12))
                .margin(const EdgeInsets.only(bottom: 8))
                .make()
          ],
        ),
      ),
    );
  }
}
