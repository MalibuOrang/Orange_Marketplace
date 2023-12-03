import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/auth_controller.dart';
import 'package:orange_marketplace/views/Byer_ui/home_screen_byer/home.dart';
import 'package:orange_marketplace/views/Seller_ui/home_screen_seller/home.dart';
import 'package:orange_marketplace/views/splash_screen/choose_registration.dart';

class ChooseRegistrationController extends GetxController {
  getTypeUser(collection) async {
    var data = await firestore
        .collection(collection)
        .where('id', isEqualTo: currentUser!.uid)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['type_registration'].toString();
      }
    });
    return data;
  }

  checkCurrentUser(context) async {
    try {
      StreamSubscription<User?>? authSubscription;
      authSubscription = auth.authStateChanges().listen((User? user) async {
        if (user == null) {
          Get.offAll(() => const ChooseRegistrationScreen());
          authSubscription?.cancel();
        } else {
          if (await getTypeUser(userCollection) == "byer") {
            Get.offAll(() => const HomeByer());
            AuthController().switchStatusOnline(
              collection: userCollection,
              status: true,
            );
            authSubscription?.cancel();
          } else if (await getTypeUser(vendorCollection) == "seller") {
            Get.offAll(() => const HomeSeller());
            AuthController().switchStatusOnline(
              collection: vendorCollection,
              status: true,
            );
            authSubscription?.cancel();
          } else {
            Get.offAll(() => const ChooseRegistrationScreen());
            authSubscription?.cancel();
          }
        }
      });
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
