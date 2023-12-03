import 'package:flutter/material.dart';
import 'package:orange_marketplace/constant/consts.dart';

Widget customTextFieldSingUpSeller(
    {controller, IconData? icon, String? hintText, required bool hintPass}) {
  return TextFormField(
    obscureText: hintPass,
    controller: controller,
    decoration: InputDecoration(
      filled: true,
      fillColor: textfieldGrey,
      prefixIcon: Icon(
        icon,
        color: purpleColor,
      ),
      border: InputBorder.none,
      hintText: hintText,
    ),
  );
}
