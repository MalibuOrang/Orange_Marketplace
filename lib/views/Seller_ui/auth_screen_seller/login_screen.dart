import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/views/Seller_ui/auth_screen_seller/signup_screen.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/custom_textfield_singup_seller.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/normal_text.dart';
import '../../../widgets/our_button.dart';
import '../home_screen_seller/home.dart';

class LoginScreenSeller extends StatelessWidget {
  const LoginScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: purpleColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.heightBox,
              normalText(text: welcome, size: 18.0),
              20.heightBox,
              Row(
                children: [
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
                  10.widthBox,
                  boldText(text: appname, size: 20.0),
                ],
              ),
              40.heightBox,
              normalText(text: loginTo, size: 18.0, color: lightGrey),
              10.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextFieldSingUpSeller(
                        hintPass: false,
                        controller: controller.loginEmailController,
                        icon: Icons.email,
                        hintText: emailHint),
                    10.heightBox,
                    customTextFieldSingUpSeller(
                        hintPass: true,
                        controller: controller.loginPasswordController,
                        icon: Icons.lock,
                        hintText: retypePassword),
                    10.heightBox,
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: normalText(
                              text: forgotPassword, color: purpleColor)),
                    ),
                    15.heightBox,
                    SizedBox(
                      width: context.screenWidth - 100,
                      child: controller.isloading.value
                          ? loadingIndicator(color: purpleColor)
                          : ourButton(
                              color: purpleColor,
                              title: login,
                              onPress: () async {
                                controller.pressLoginButton(context,
                                    screen: const HomeSeller(),
                                    typeCollection: vendorCollection);
                              },
                            ),
                    ),
                    5.heightBox,
                    createNewAccount.text.color(fontGrey).make(),
                    5.heightBox,
                    ourButton(
                        color: purpleColor,
                        title: signup,
                        textColor: whiteColor,
                        onPress: () {
                          Get.to(() => const SingupScreenSeller());
                        }).box.width(context.screenWidth - 100).make(),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .outerShadowMd
                    .padding(const EdgeInsets.all(8))
                    .make(),
              ),
              10.heightBox,
              Center(child: normalText(text: anyProblem, color: lightGrey)),
              const Spacer(),
              Center(child: boldText(text: credit)),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
