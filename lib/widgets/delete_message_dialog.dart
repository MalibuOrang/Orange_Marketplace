import 'package:flutter/material.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/widgets/our_button.dart';

Widget deleteDialog(context, String textDialog, deleteFunc) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Confirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
        const Divider(),
        10.heightBox,
        textDialog.text.size(16).color(darkFontGrey).make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ourButton(
                color: orangeColor,
                onPress: () {
                  deleteFunc();
                  Navigator.pop(context);
                },
                textColor: whiteColor,
                title: "Yes"),
            ourButton(
                color: orangeColor,
                onPress: () {
                  Navigator.pop(context);
                },
                textColor: whiteColor,
                title: "No"),
          ],
        )
      ],
    ).box.color(lightGrey).padding(const EdgeInsets.all(12)).roundedSM.make(),
  );
}
