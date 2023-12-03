import 'package:flutter/material.dart';
import 'package:orange_marketplace/constant/consts.dart';

Widget deleteButtons({onPress}) {
  return IconButton(
    onPressed: onPress,
    icon: const Icon(
      Icons.delete,
      size: 20,
    ),
  ).box.rounded.white.height(35.0).width(35.0).shadow2xl.make();
}
