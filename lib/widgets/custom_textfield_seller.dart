import 'package:flutter/material.dart';
import 'package:orange_marketplace/constant/consts.dart';

import 'normal_text.dart';

Widget customTextFieldSeller(
    {String? title, String? hint, controller, isDesc = false, isPass = false}) {
  return TextFormField(
    controller: controller,
    obscureText: isPass,
    style: const TextStyle(color: whiteColor),
    maxLines: isDesc ? 4 : 1,
    decoration: InputDecoration(
      isDense: true,
      label: normalText(text: title),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: whiteColor,
          )),
      hintText: hint,
      filled: true,
      hintStyle: const TextStyle(color: lightGrey),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: whiteColor,
          )),
    ),
  );
}
