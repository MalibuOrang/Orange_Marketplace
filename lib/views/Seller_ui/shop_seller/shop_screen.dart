import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/profile_controller.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';

import '../../../widgets/custom_textfield_seller.dart';
import '../../../widgets/normal_text.dart';

class ShopSettingsScreenSeller extends StatelessWidget {
  const ShopSettingsScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: shopSettings, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(color: whiteColor)
                : TextButton(
                    onPressed: () async {
                      await controller.onPressSaveShopInfoBut(context);
                    },
                    child: normalText(text: save)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              customTextFieldSeller(
                title: shopName,
                hint: nameHint,
                controller: controller.shopNameController,
              ),
              10.heightBox,
              customTextFieldSeller(
                title: address,
                hint: shopAddressHint,
                controller: controller.shopAddressController,
              ),
              10.heightBox,
              customTextFieldSeller(
                title: mobile,
                hint: shopMobileHint,
                controller: controller.shopMobileController,
              ),
              10.heightBox,
              customTextFieldSeller(
                title: website,
                hint: shopWebsiteHint,
                controller: controller.shopWebsiteController,
              ),
              10.heightBox,
              customTextFieldSeller(
                isDesc: true,
                title: description,
                hint: shopDescHint,
                controller: controller.shopDescController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
