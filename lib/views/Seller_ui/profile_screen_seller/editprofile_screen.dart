import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/profile_controller.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../widgets/custom_textfield_seller.dart';
import '../../../widgets/normal_text.dart';

class EditProfileScreenSeller extends StatefulWidget {
  const EditProfileScreenSeller({super.key});

  @override
  State<EditProfileScreenSeller> createState() =>
      _EditProfileScreenSellerState();
}

class _EditProfileScreenSellerState extends State<EditProfileScreenSeller> {
  var controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(color: whiteColor)
                : TextButton(
                    onPressed: () async {
                      await controller.onPressSaveProfile(
                          context, controller.snapshotDataSeller);
                    },
                    child: normalText(text: save)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              controller.snapshotDataSeller['imageUrl'] == '' &&
                      controller.profieImgPath.isEmpty
                  ? Image.asset(
                      imgProduct,
                      width: 100,
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAlias).make()
                  : controller.snapshotDataSeller['imageUrl'] != '' &&
                          controller.profieImgPath.isEmpty
                      ? Image.network(
                          controller.snapshotDataSeller['imageUrl'],
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      : Image.file(
                          File(controller.profieImgPath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
                onPressed: () {
                  controller.changeImage(context);
                },
                child: normalText(text: changeImage, color: fontGrey),
              ),
              10.heightBox,
              const Divider(
                color: whiteColor,
              ),
              10.heightBox,
              customTextFieldSeller(
                  title: name,
                  hint: name,
                  controller: controller.nameController),
              30.heightBox,
              Align(
                  alignment: Alignment.centerLeft,
                  child: boldText(text: "Change your password")),
              10.heightBox,
              customTextFieldSeller(
                  title: password,
                  hint: passwordHint,
                  controller: controller.oldpassController,
                  isPass: true),
              20.heightBox,
              customTextFieldSeller(
                  title: confirmPass,
                  hint: passwordHint,
                  controller: controller.newpassController,
                  isPass: true),
            ],
          ),
        ),
      ),
    );
  }
}
