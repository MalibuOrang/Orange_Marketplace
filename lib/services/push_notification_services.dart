import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/views/Byer_ui/chat_screen_byer/messaging_screen.dart';
import 'package:orange_marketplace/views/Byer_ui/orders_screen_byer/orders_screen.dart';
import 'package:orange_marketplace/views/Seller_ui/chat_screen_seller/messages_screen.dart';
import 'package:orange_marketplace/views/splash_screen/splash_screen.dart';

class PushNotificationServices {
  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    } else if (message.data['type'] == 'byer') {
      Get.to(() => const MessagesScreenByer());
    } else if (message.data['type'] == 'seller') {
      Get.to(() => const MessagesScreenSeller());
    } else if (message.data['type'] == '') {
      Get.to(() => const OrdersScreenByer());
    } else {
      Get.to(() => const SplashScreen());
    }
  }

  Future<void> initPushNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
  }

  static Future<void> sendPushNotification(token, String username, String msg,
      String uid, String? typeNotification) async {
    try {
      final body = {
        "to": token,
        "notification": {
          "title": username,
          "body": msg,
          "image": notificationImg,
          "app_name": appname,
          "android_channel_id": "msg_channel",
        },
        "data": {"type": typeNotification, "UID": uid}
      };
      var res =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader: 'key=$serverKey'
              },
              body: jsonEncode(body));
      log('Response status:  ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotification : $e');
    }
  }
}
