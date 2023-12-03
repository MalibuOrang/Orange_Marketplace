import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/constant/payment_config_const.dart';
import 'package:orange_marketplace/controllers/auth_controller.dart';
import 'package:orange_marketplace/services/push_notification_services.dart';
import 'package:orange_marketplace/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  Stripe.publishableKey = publishableStripeKey;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const UMarket());
}

class UMarket extends StatefulWidget {
  const UMarket({super.key});

  @override
  State<UMarket> createState() => _UMarketState();
}

class _UMarketState extends State<UMarket> with WidgetsBindingObserver {
  var controller = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PushNotificationServices().initPushNotification();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    await controller.switchStatusOnlineLifeApp(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            // to set app bar icons color
            iconTheme: IconThemeData(
              color: lightGrey,
            ),
            backgroundColor: Colors.transparent,
          ),
          fontFamily: regular),
      home: const SplashScreen(),
    );
  }
}
