import 'package:flutter/material.dart';
import 'package:orange_marketplace/constant/colors.dart';

Widget loadingIndicator({Color? color = orangeColor}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(color),
    ),
  );
}
