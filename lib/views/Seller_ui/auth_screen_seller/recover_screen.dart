import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/recover_controller.dart';
import '../../../widgets/custom_textfield_singup_seller.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/normal_text.dart';
import '../../../widgets/our_button.dart';

class RecoverPassScreenSeller extends StatelessWidget {
  const RecoverPassScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(RecoverPassController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: purpleColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              normalText(text: recoverPass, size: 18.0, color: lightGrey),
              10.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextFieldSingUpSeller(
                        hintPass: false,
                        controller: controller.emailRecoverController,
                        icon: Icons.email,
                        hintText: emailHint),
                    10.heightBox,
                    SizedBox(
                      width: context.screenWidth - 100,
                      child: controller.isRecover.value
                          ? loadingIndicator(color: purpleColor)
                          : ourButton(
                              color: purpleColor,
                              title: login,
                              onPress: () async {
                                await controller.resetPassFromEmail(context);
                              },
                            ),
                    ),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .outerShadowMd
                    .padding(const EdgeInsets.all(8))
                    .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
