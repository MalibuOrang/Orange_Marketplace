import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';

class RecoverPassController extends GetxController {
  var isRecover = false.obs;
  //text controllers
  var emailRecoverController = TextEditingController();
  Future resetPassFromEmail(context) async {
    isRecover(true);
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailRecoverController.text.trim());
      VxToast.show(context, msg: recoverPasswordStatus);
      isRecover(false);
      Get.back();
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.message.toString());
      isRecover(false);
    }
  }
}
