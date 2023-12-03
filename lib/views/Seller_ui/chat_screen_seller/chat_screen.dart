import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../controllers/chat_controller.dart';
import '../../../widgets/normal_text.dart';
import 'components/chat_bubble.dart';

class ChatScreenSeller extends StatelessWidget {
  const ChatScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
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
        title: boldText(text: chats, size: 16.0, color: fontGrey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => Column(children: [
            controller.isLoading.value
                ? Center(child: loadingIndicator(color: purpleColor))
                : Expanded(
                    child: StreamBuilder(
                        stream: FirestoreServices.getChatMessages(
                            controller.currentChatDocId.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: loadingIndicator(color: purpleColor),
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
                                    controller.scrollMessageControllerSeller,
                                children: snapshot.data!.docs
                                    .mapIndexed((currentValue, index) {
                                  var data = snapshot.data!.docs[index];
                                  return chatBubble(context, data,
                                      controller.currentChatDocId.value,
                                      messageId: data.id);
                                }).toList());
                          }
                        }),
                  ),
            10.heightBox,
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.msgControllerSeller,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: "Enter message",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: purpleColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: purpleColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await controller.onPressSendMsgBut(context);
                    },
                    icon: const Icon(Icons.send),
                    color: purpleColor,
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
