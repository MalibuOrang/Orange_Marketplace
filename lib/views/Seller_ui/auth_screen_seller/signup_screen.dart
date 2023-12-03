import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/views/Seller_ui/home_screen_seller/home.dart';
import 'package:orange_marketplace/widgets/custom_textfield_singup_seller.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/our_button.dart';

class SingupScreenSeller extends StatefulWidget {
  const SingupScreenSeller({super.key});

  @override
  State<SingupScreenSeller> createState() => _SingupScreenByerState();
}

class _SingupScreenByerState extends State<SingupScreenSeller> {
  var controller = Get.put(AuthController());
  // text controller
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            Image.asset(
              icLogo,
              width: 70,
              height: 70,
            )
                .box
                .border(color: whiteColor)
                .rounded
                .padding(const EdgeInsets.all(8))
                .make(),
            15.heightBox,
            "Sell with the $appname"
                .text
                .fontFamily(bold)
                .white
                .size(18)
                .make(),
            10.heightBox,
            Obx(
              () => Column(
                children: [
                  customTextFieldSingUpSeller(
                      hintPass: false,
                      controller: controller.nameController,
                      icon: Icons.person,
                      hintText: nameHint),
                  10.heightBox,
                  customTextFieldSingUpSeller(
                      hintPass: false,
                      controller: controller.singUpEmailController,
                      icon: Icons.email,
                      hintText: emailHint),
                  10.heightBox,
                  customTextFieldSingUpSeller(
                      hintPass: true,
                      controller: controller.singUpPasswordController,
                      icon: Icons.password,
                      hintText: password),
                  10.heightBox,
                  customTextFieldSingUpSeller(
                      hintPass: true,
                      controller: controller.singUpPasswordRetypeController,
                      icon: Icons.lock,
                      hintText: retypePassword),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: forgetPass.text.color(purpleColor).make())),
                  5.heightBox,
                  Row(
                    children: [
                      Checkbox(
                        checkColor: whiteColor,
                        activeColor: purpleColor,
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
                      ? loadingIndicator(color: purpleColor)
                      : ourButton(
                          color: controller.isCheck == true
                              ? purpleColor
                              : lightGrey,
                          title: signup,
                          textColor: whiteColor,
                          onPress: () async {
                            controller.pressSingupButton(context,
                                screen: const HomeSeller());
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
    );
  }
}
