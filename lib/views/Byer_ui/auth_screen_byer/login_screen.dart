import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/auth_controller.dart';
import 'package:orange_marketplace/views/Byer_ui/auth_screen_byer/recover_password.dart';
import 'package:orange_marketplace/views/Byer_ui/home_screen_byer/home.dart';
import 'package:orange_marketplace/widgets/applogo_widget.dart';
import 'package:orange_marketplace/widgets/bg_widget.dart';
import 'package:orange_marketplace/widgets/custom_textfield_byer.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import 'package:orange_marketplace/widgets/our_button.dart';
import 'signup_screen.dart';

class LoginScreenByer extends StatelessWidget {
  const LoginScreenByer({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            appLogoWidget(icAppLogo),
            15.heightBox,
            "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
            10.heightBox,
            Obx(
              () => Column(
                children: [
                  customTextFieldByer(
                      hint: emailHint,
                      title: email,
                      isPass: false,
                      controller: controller.loginEmailController),
                  10.heightBox,
                  customTextFieldByer(
                      hint: passwordHint,
                      title: password,
                      isPass: true,
                      controller: controller.loginPasswordController),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {
                            Get.to(() => const RecoverPassByer());
                          },
                          child: forgetPass.text.make())),
                  5.heightBox,
                  controller.isloading.value
                      ? loadingIndicator(color: orangeColor)
                      : ourButton(
                          color: orangeColor,
                          title: login,
                          textColor: whiteColor,
                          onPress: () async {
                            controller.pressLoginButton(context,
                                screen: const HomeByer(),
                                typeCollection: userCollection);
                          }).box.width(context.screenWidth - 50).make(),
                  5.heightBox,
                  createNewAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(
                      color: lightGolden,
                      title: signup,
                      textColor: orangeColor,
                      onPress: () {
                        Get.to(() => const SingupScreenByer());
                      }).box.width(context.screenWidth - 50).make(),
                  10.heightBox,
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ),
          ],
        ),
      ),
    ));
  }
}
