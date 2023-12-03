import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/constant/lists.dart';
import 'package:orange_marketplace/constant/payment_config_const.dart';
import 'package:orange_marketplace/controllers/orders_controller.dart';
import 'package:orange_marketplace/services/push_notification_services.dart';
import 'package:orange_marketplace/views/Byer_ui/cart_screen_byer/payment_method.dart';
import 'package:pay/pay.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_stripe/flutter_stripe.dart';

import '../views/Byer_ui/home_screen_byer/home.dart';

class PaymentController extends GetxController {
  String os = Platform.operatingSystem;
  var paymentIndex = 0.obs;
  late Map<String, dynamic> result = {};
  var labelItem = [];
  Map<String, dynamic>? paymentIntent;
  dynamic productCartSnapshot = Get.arguments[0];
  String totalAmount = Get.arguments[1];
  changePaymentInfoOs() {
    switch (os) {
      case 'ios':
        paymentMethodImg[0] = imgApplePay;
        paymentMethods[0] = applePay;
        break;
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  getProductDetails() {
    labelItem.clear();
    for (var i = 0; i < productCartSnapshot.length; i++) {
      labelItem.add({
        'title': productCartSnapshot[i]['title'],
      });
    }
  }

  @override
  void onInit() {
    createPaymentItemList();
    changePaymentInfoOs();
    super.onInit();
  }

  static const paymentItem = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  List<PaymentItem> createPaymentItemList() {
    getProductDetails();
    List<PaymentItem> paymentItems = List.from(paymentItem);
    for (var item in labelItem) {
      paymentItems.add(PaymentItem(
        label: item['title'],
        amount: totalAmount,
        status: PaymentItemStatus.final_price,
      ));
    }

    return paymentItems;
  }

  Pay payClient = Pay(({
    PayProvider.google_pay:
        PaymentConfiguration.fromJsonString(defaultGooglePay),
    PayProvider.apple_pay: PaymentConfiguration.fromJsonString(defaultApplePay),
  }));
  onGooglePayPressed(Map<String, dynamic> result) async {
    try {
      result = await payClient.showPaymentSelector(
        PayProvider.google_pay,
        paymentItem,
      );
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.message);
    }
  }

  onApplePayPressed(Map<String, dynamic> result) async {
    try {
      result = await payClient.showPaymentSelector(
        PayProvider.apple_pay,
        paymentItem,
      );
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.message);
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': Uri.encodeQueryComponent(calculateAmount(amount)),
        'currency': Uri.encodeQueryComponent(currency),
        'payment_method_types[]': Uri.encodeQueryComponent('card')
      };
      final url = Uri.parse("https://api.stripe.com/v1/payment_intents");
      final response = await http.post(
        url,
        headers: {
          'Authorization': "Bearer $stripeKey",
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (e, s) {
      // ignore: avoid_print
      print("Error creating checkout session $e, $s");
      return {};
    }
  }

  Future<void> makePaymentStripe(context) async {
    try {
      paymentIntent = await createPaymentIntent(totalAmount, 'USD');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        style: ThemeMode.dark,
        merchantDisplayName: appname,
      ));
      displayPaymentSheet(context);
    } on StripeException catch (e) {
      VxToast.show(context, msg: "Payment was canceled $e");
    } catch (e, s) {
      // ignore: avoid_print
      print("Get some error $e , $s");
    }
  }

  calculateAmount(String amount) {
    final calculateAmount = (int.parse(amount)) * 100;
    return calculateAmount.toString();
  }

  succesPaymentEvent(controller, String statusPay, String staus,
      String msgNotification) async {
    OrdersController().changeStatus(statusPay, staus, controller.docId);
    await PushNotificationServices.sendPushNotification(
        controller.getValueFromList('user_token'),
        "$msgNotification, $username",
        controller.getValueFromList('title'),
        currentUser!.uid,
        "payment_msg");
    Get.offAll(() => const HomeByer());
  }

  updateMethodPayment(controller, String status) async {
    await OrdersController()
        .changeStatus("payment_method", status, controller.docId);
  }

  void cancelPaymentEvent(context, String cancelMsg) {
    VxToast.show(context, msg: cancelMsg);
    Get.to(() => const PaymentMethodsByer());
  }

  displayPaymentSheet(context) async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) =>
              VxToast.show(context, msg: "Order payment successfully"))
          .onError((error, stackTrace) => "Error $error, $stackTrace");
    } on StripeException catch (e) {
      VxToast.show(context, msg: "Order payment failed $e");
    } catch (e) {
      // ignore: avoid_print
      print("Error $e");
    }
  }

  onPressPaymentButton(controller, context) async {
    switch (paymentIndex.value) {
      case 0:
        switch (os) {
          case 'ios':
            await onApplePayPressed(result);
            break;
          default:
            await onGooglePayPressed(result);
        }
        switch (result.isNotEmpty) {
          case true:
            await succesPaymentEvent(controller, 'status_payment', "Paid",
                "You have paid order from");
            await updateMethodPayment(
                controller, paymentMethods[paymentIndex.value]);
            break;
          case false:
            cancelPaymentEvent(
                context, "Your payment is not successfully try again");
        }
        break;
      case 1:
        await makePaymentStripe(context);
        switch (paymentIntent!.isNotEmpty) {
          case true:
            await succesPaymentEvent(controller, 'status_payment', "Paid",
                "You have paid order from");
            await updateMethodPayment(
                controller, paymentMethods[paymentIndex.value]);
            break;
          case false:
            cancelPaymentEvent(context, "Your payment was canceled");
            break;
        }
        break;
      case 2:
        await succesPaymentEvent(controller, 'status_payment', "Cash delivery",
            "You have cash delivery order from");
        await updateMethodPayment(
            controller, paymentMethods[paymentIndex.value]);
        break;
    }
  }
}
