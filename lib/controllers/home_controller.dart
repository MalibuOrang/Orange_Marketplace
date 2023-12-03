import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';

class HomeController extends GetxController {
  var currentNavIndex = 0.obs;

  var searchController = TextEditingController();
  @override
  void onInit() async {
    _loadUserNames();
    super.onInit();
  }

  _loadUserNames() async {
    username = await getUserInfo(userCollection, "name") ??
        await getUserInfo(vendorCollection, "vendor_name");
    userToken = await getUserInfo(userCollection, "user_token") ??
        await getUserInfo(vendorCollection, "user_token");
  }

  Future<dynamic> getUserInfo(String collection, String typeName) async {
    var snapshot = await firestore
        .collection(collection)
        .where('id', isEqualTo: currentUser!.uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.single[typeName];
    }

    return null;
  }

  Stream<dynamic> getUserStatusOnlineStream(
      String collection, String uid, String typeName, context) {
    return firestore
        .collection(collection)
        .where('id', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.single[typeName];
      } else {
        VxToast.show(context, msg: "Something is wrong");
      }
    });
  }
}
