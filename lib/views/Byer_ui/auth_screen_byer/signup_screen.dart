import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/auth_controller.dart';
import 'package:orange_marketplace/views/Byer_ui/home_screen_byer/home.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../widgets/applogo_widget.dart';
import '../../../widgets/bg_widget.dart';
import '../../../widgets/custom_textfield_byer.dart';
import '../../../widgets/our_button.dart';

class SingupScreenByer extends StatefulWidget {
  const SingupScreenByer({super.key});

  @override
  State<SingupScreenByer> createState() => _SingupScreenByerState();
}

class _SingupScreenByerState extends State<SingupScreenByer> {
  var controller = Get.put(AuthController());
  // text controller

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            appLogoWidget(icAppLogo),
            15.heightBox,
            "Join the $appname".text.fontFamily(bold).white.size(18).make(),
            10.heightBox,
            Obx(
              () => Column(
                children: [
                  customTextFieldByer(
                      hint: nameHint,
                      title: name,
                      controller: controller.nameController,
                      isPass: false),
                  10.heightBox,
                  customTextFieldByer(
                      hint: emailHint,
                      title: email,
                      controller: controller.singUpEmailController,
                      isPass: false),
                  10.heightBox,
                  customTextFieldByer(
                      hint: passwordHint,
                      title: password,
                      controller: controller.singUpPasswordController,
                      isPass: true),
                  10.heightBox,
                  customTextFieldByer(
                      hint: passwordHint,
                      title: retypePassword,
                      controller: controller.singUpPasswordRetypeController,
                      isPass: true),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {}, child: forgetPass.text.make())),
                  5.heightBox,
                  Row(
                    children: [
                      Checkbox(
                        checkColor: orangeColor,
                        value: controller.isCheck,
                        onChanged: (newValue) {
                          setState(() {
                            controller.isCheck = newValue;
                          });
                        },
                      ),
                      10.widthBox,
                      Expanded(
                        child: RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                              text: "I agree to the ",
                              style: TextStyle(
                                fontFamily: regular,
                                color: fontGrey,
                              )),
                          TextSpan(
                              text: termAndCond,
                              style: TextStyle(
                                fontFamily: regular,
                                color: orangeColor,
                              )),
                          TextSpan(
                              text: " & ",
                              style: TextStyle(
                                fontFamily: regular,
                                color: fontGrey,
                              )),
                          TextSpan(
                              text: privacyPolicy,
                              style: TextStyle(
                                fontFamily: regular,
                                color: orangeColor,
                              )),
                        ])),
                      ),
                    ],
                  ),
                  5.heightBox,
                  controller.isloading.value
                      ? loadingIndicator(color: orangeColor)
                      : ourButton(
                          color: controller.isCheck == true
                              ? orangeColor
                              : lightGrey,
                          title: signup,
                          textColor: whiteColor,
                          onPress: () async {
                            controller.pressSingupButton(context,
                                screen: const HomeByer());
                          },
                        ).box.width(context.screenWidth - 50).make(),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      alreadyHaveAccount.text.color(fontGrey).make(),
                      login.text.color(orangeColor).make().onTap(() {
                        Get.back();
                      })
                    ],
                  ),
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
