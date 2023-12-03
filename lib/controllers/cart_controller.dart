import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/views/Byer_ui/cart_screen_byer/shopping_screen.dart';

import '../services/push_notification_services.dart';

class CartController extends GetxController {
  var totalP = 0.obs;
  String? contryCode = "";
  String country = "";
  String? state = "";
  String? city = "";
  // text controller for shopping details
  var addressController = TextEditingController();
  var postalCodeController = TextEditingController();
  var phoneNumberController = TextEditingController();

  late dynamic productSnapshot;
  String? docId;
  var products = [];
  var vendorId = [];
  var placingOrder = false.obs;

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['tprice'].toString());
    }
  }

  placeMyOrder(context, {required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();
    var newDocOrder = firestore.collection(ordersCollection).doc();
    newDocOrder.set({
      'order_code': "233981237",
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': state,
      'order_by_country': country,
      'order_by_city': city,
      'order_by_phone': '+${contryCode! + phoneNumberController.text}',
      'order_by_postalcode': postalCodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': "",
      'order_placed': true,
      'order_confirmed': false,
      'order_on_delivery': false,
      'order_delivery': false,
      'status_payment': "Unpaid",
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
      'vendors': vendorId,
    }).then((value) async {
      VxToast.show(context, msg: "Order placed successfully");
      await PushNotificationServices.sendPushNotification(
          getValueFromList('user_token'),
          "Your product ordered from a user $username",
          getValueFromList('title'),
          currentUser!.uid,
          "orders_msg");
      await clearCart();
      totalP.value = 0;
    });
    docId = newDocOrder.id;

    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'qty': productSnapshot[i]['qty'],
        'tprice': productSnapshot[i]['tprice'],
        'title': productSnapshot[i]['title'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'user_token': productSnapshot[i]['user_token'],
      });
      vendorId.add(
        productSnapshot[i]['vendor_id'],
      );
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }

  getValueFromList(String param) {
    String token = products.map((product) => product[param]).join(", ");
    return token;
  }

  onPressContinueButton(context, {required Widget screan}) async {
    if (addressController.text.length > 10 &&
        country.isNotEmpty &&
        postalCodeController.text.length <= 6) {
      await placeMyOrder(context, totalAmount: totalP.value);
      String totalAmount;
      totalAmount = totalP.value.toString();
      Get.to(() => screan, arguments: [
        productSnapshot,
        totalAmount,
      ]);
    } else {
      VxToast.show(context, msg: "Please fill the form");
    }
  }

  buttonFunctionProccesShopping(context) {
    if (totalP.value != 0) {
      Get.to(() => const ShopingDetailsByer());
    } else {
      VxToast.show(context, msg: errorProcesShopping);
    }
  }
}
