import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/services/delete_button_function.dart';
import 'package:orange_marketplace/widgets/delete_button.dart';
import '../../../../constant/consts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

Widget senderBubble(BuildContext context, DocumentSnapshot data, dynamic chatId,
    {String? messageId}) {
  var t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(bottom: 8),
    decoration: data['uid'] == currentUser!.uid
        ? const BoxDecoration(
            color: orangeColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ))
        : const BoxDecoration(
            color: darkFontGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
    child: Column(
      crossAxisAlignment: data['uid'] == currentUser!.uid
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        '${data['msg']}'.text.white.size(16).make(),
        data['msg_read'] == false
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : const Icon(
                Icons.done_all,
                color: Colors.green,
              ),
        Row(
          mainAxisAlignment: data['uid'] == currentUser!.uid
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            time.text.color(whiteColor.withOpacity(0.5)).make(),
            data['uid'] == currentUser!.uid
                ? deleteButtons(onPress: () {
                    DeleteFuctinoButton().onPressDeleteBut(context, data,
                        deleting: () async {
                      FirestoreServices.deleteMesFromChat(chatId, messageId);
                      await FirestoreServices.updateLastMsg(chatId);
                    }, question: "Delete your message?");
                  })
                : const SizedBox()
          ],
        )
      ],
    ),
  );
}
