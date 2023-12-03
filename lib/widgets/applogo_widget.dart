import 'package:flutter/material.dart';
import 'package:orange_marketplace/constant/consts.dart';

Widget appLogoWidget(imageSingup) {
  return Image.asset(imageSingup)
      .box
      .white
      .size(77, 77)
      .padding(const EdgeInsets.all(8))
      .rounded
      .make();
}
