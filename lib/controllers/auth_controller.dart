import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';

import '../services/firestore_services.dart';

class AuthController extends GetxController {
  bool? isCheck = false;
  var isloading = false.obs;
  //text controllers
  var loginEmailController = TextEditingController();
  var loginPasswordController = TextEditingController();
  var nameController = TextEditingController();
  var singUpEmailController = TextEditingController();
  var singUpPasswordController = TextEditingController();
  var singUpPasswordRetypeController = TextEditingController();
  @override
  void onInit() async {
    userToken = await FirestoreServices.getMessagesToken();
    super.onInit();
  }

  //login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: loginEmailController.text,
          password: loginPasswordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

// status online update
  switchStatusOnline({required collection, required bool status}) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection(collection)
          .where('id', isEqualTo: currentUser!.uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference store = querySnapshot.docs[0].reference;
        store.update({
          'status_online': status,
        });
      } else {
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

// update token method
  updateUserToken({required collection, context}) async {
    DocumentReference store =
        firestore.collection(collection).doc(currentUser!.uid);
    if (userToken != null && currentUser != null) {
      await store.update({
        'user_token': userToken,
      });
    } else {
      return VxToast.show(context, msg: 'Dont update user token!');
    }
  }

  // onPress login button
  pressLoginButton(context,
      {required Widget screen, required typeCollection}) async {
    isloading(true);
    await loginMethod(context: context).then((value) async {
      if (value != null) {
        currentUser = value.user;
        await updateUserToken(collection: typeCollection, context: context);
        VxToast.show(context, msg: loggedin);
        Get.offAll(() => screen);
        await switchStatusOnline(
          collection: typeCollection,
          status: true,
        );
      } else {
        isloading(false);
      }
    });
  }

  // onPress singup button
  pressSingupButton(context, {required Widget screen}) async {
    if (isCheck != false) {
      isloading(true);
      try {
        await signupMethod(
                context: context,
                email: singUpEmailController.text,
                password: singUpPasswordController.text)
            .then((value) {
          currentUser = value?.user;
          return storeUserData(
            collection: userCollection,
            email: singUpEmailController.text,
            password: singUpPasswordController.text,
            name: nameController.text,
          );
        }).then((value) {
          VxToast.show(context, msg: loggedin);
          Get.offAll(() => screen);
        });
      } catch (e) {
        auth.signOut();
        // ignore: use_build_context_synchronously
        VxToast.show(context, msg: e.toString());
        isloading(false);
      }
    }
  }

  // storing data method
  storeUserData({name, password, email, required collection}) async {
    DocumentReference store =
        firestore.collection(collection).doc(currentUser!.uid);
    if (collection == userCollection) {
      store.set({
        'name': name,
        'password': password,
        'email': email,
        'imageUrl': '',
        'id': currentUser!.uid,
        'user_token': userToken,
        'cart_count': "00",
        'type_registration': "byer",
        'wishlist_count': "00",
        'order_count': "00",
        'status_online': true,
      });
    } else if (collection == vendorCollection) {
      store.set({
        'vendor_name': name,
        'password': password,
        'email': email,
        'imageUrl': '',
        'id': currentUser!.uid,
        'user_token': userToken,
        'type_registration': "seller",
        'status_online': true,
      });
    }
  }

  //signout method
  singoutMethod(context) async {
    try {
      await auth.signOut();
      currentUser = null;
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  switchStatusOnlineLifeApp(state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        await switchStatusOnline(
              collection: userCollection,
              status: false,
            ) ??
            await switchStatusOnline(
                collection: vendorCollection, status: false);
        break;
      case AppLifecycleState.paused:
        await switchStatusOnline(collection: userCollection, status: false) ??
            await switchStatusOnline(
                collection: vendorCollection, status: false);
        break;
      case AppLifecycleState.resumed:
        await switchStatusOnline(collection: userCollection, status: true) ??
            await switchStatusOnline(
                collection: vendorCollection, status: true);
        break;
      default:
        await switchStatusOnline(collection: userCollection, status: false) ??
            await switchStatusOnline(
                collection: vendorCollection, status: false);
        break;
    }
  }
}
