import 'package:flutter/material.dart';
import 'package:orange_marketplace/constant/consts.dart';

Widget customTextFieldByer({String? title, String? hint, controller, isPass}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(Vx.orange500).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        autofocus: true,
        obscureText: isPass,
        controller: controller,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            color: orangeColor,
          )),
        ),
      ),
      5.heightBox
    ],
  );
}
