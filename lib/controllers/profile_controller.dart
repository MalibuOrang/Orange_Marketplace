import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:path/path.dart' show basename;

class ProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotDataByer;
  late QueryDocumentSnapshot snapshotDataSeller;
  var profieImgPath = ''.obs;
  var profileImageLink = '';
  var isloading = false.obs;
  //editing profile
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();
  //editing shop settings
  var shopNameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopWebsiteController = TextEditingController();
  var shopDescController = TextEditingController();
  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profieImgPath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var filename = basename(profieImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profieImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({typeName, name, password, imgUrl, required collection}) async {
    var store = firestore.collection(collection).doc(currentUser!.uid);
    await store.set({
      '$typeName': name,
      'password': password,
      'imageUrl': imgUrl,
    }, SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    try {
      final cred =
          EmailAuthProvider.credential(email: email, password: password);
      await currentUser!.reauthenticateWithCredential(cred);
      await currentUser!.updatePassword(newpassword);
    } catch (error) {
      return error.toString();
    }
  }

  updateShopInfo(
      {required String shopName,
      shopAddress,
      shopMobile,
      shopWebsite,
      shopDesc}) async {
    var store = firestore.collection(vendorCollection).doc(currentUser!.uid);
    await store.set({
      'shop_name': shopName,
      'shop_address': shopAddress,
      'shop_mobile': shopMobile,
      'shop_website': shopWebsite,
      'shop_desc': shopDesc,
    }, SetOptions(merge: true));
    isloading(false);
  }

  onPressSaveProfile(context, data) async {
    isloading(true);
    //if image is not selected
    if (profieImgPath.value.isNotEmpty) {
      await uploadProfileImage();
    } else {
      profileImageLink = data['imageUrl'];
    }
    //if old password matches data base
    if (data['password'] == oldpassController.text) {
      await changeAuthPassword(
        email: data['email'],
        password: oldpassController.text,
        newpassword: newpassController.text,
      );
      await updateProfile(
        typeName: "name",
        collection: userCollection,
        imgUrl: profileImageLink,
        name: nameController.text,
        password: newpassController.text,
      );

      VxToast.show(context, msg: "Saved successfully");
    } else if (oldpassController.text.isEmptyOrNull &&
        newpassController.text.isEmptyOrNull) {
      await updateProfile(
        typeName: "name",
        collection: userCollection,
        imgUrl: profileImageLink,
        name: nameController.text,
        password: snapshotDataSeller['password'],
      );
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: "Update only profile");
    } else if (snapshotDataSeller['password'] != oldpassController.text &&
        oldpassController.text.isNotEmptyAndNotNull &&
        newpassController.text.isNotEmptyAndNotNull) {
      await changeAuthPassword(
        email: data['email'],
        password: oldpassController.text,
        newpassword: newpassController.text,
      );
      await updateProfile(
        typeName: "name",
        collection: userCollection,
        imgUrl: profileImageLink,
        name: nameController.text,
        password: newpassController.text,
      );
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: "Saved successfully");
    } else {
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: "Some error occurred!");
      isloading(false);
    }
  }

  onPressSaveShopInfoBut(context) async {
    isloading(true);
    await updateShopInfo(
      shopName: shopNameController.text,
      shopAddress: shopAddressController.text,
      shopMobile: shopMobileController.text,
      shopWebsite: shopWebsiteController.text,
      shopDesc: shopDescController.text,
    );
    // ignore: use_build_context_synchronously
    VxToast.show(context, msg: "Shop info updated");
  }
}
