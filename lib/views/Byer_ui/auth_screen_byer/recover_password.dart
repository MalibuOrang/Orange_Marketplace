import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/recover_controller.dart';
import 'package:orange_marketplace/widgets/bg_widget.dart';
import 'package:orange_marketplace/widgets/custom_textfield_byer.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import 'package:orange_marketplace/widgets/our_button.dart';

class RecoverPassByer extends StatelessWidget {
  const RecoverPassByer({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(RecoverPassController());
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.2).heightBox,
              "Recover password to $appname"
                  .text
                  .white
                  .fontFamily(bold)
                  .size(15)
                  .make(),
              10.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextFieldByer(
                        hint: emailHint,
                        title: email,
                        isPass: false,
                        controller: controller.emailRecoverController),
                    10.heightBox,
                    controller.isRecover.value
                        ? loadingIndicator(color: purpleColor)
                        : ourButton(
                            color: orangeColor,
                            title: recoverPass,
                            textColor: whiteColor,
                            onPress: () async {
                              await controller.resetPassFromEmail(context);
                            }).box.width(context.screenWidth - 50).make(),
                    5.heightBox,
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(10))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
