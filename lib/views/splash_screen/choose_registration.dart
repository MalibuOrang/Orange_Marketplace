import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/constant/lists.dart';
import 'package:orange_marketplace/views/Byer_ui/auth_screen_byer/login_screen.dart';
import 'package:orange_marketplace/views/Seller_ui/auth_screen_seller/login_screen.dart';
import 'package:orange_marketplace/widgets/bg_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ChooseRegistrationScreen extends StatelessWidget {
  const ChooseRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        backgroundColor: profileColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: typeRegistration.text.fontFamily(bold).white.make(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              questionTypeRegistration.text
                  .fontFamily(bold)
                  .white
                  .makeCentered(),
              10.heightBox,
              ToggleSwitch(
                minWidth: 200,
                minHeight: 50,
                initialLabelIndex: null,
                inactiveBgColor: darkFontGrey,
                inactiveFgColor: whiteColor,
                cornerRadius: 15,
                activeBgColor: const [
                  registrationByerColor,
                  registrationSellerColor
                ],
                totalSwitches: 2,
                icons: const [Icons.shopping_bag, Icons.credit_card],
                labels: registraitonMethods,
                onToggle: (index) {
                  switch (index) {
                    case 0:
                      Get.to(() => const LoginScreenByer());
                      break;
                    case 1:
                      Get.to(() => const LoginScreenSeller());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
