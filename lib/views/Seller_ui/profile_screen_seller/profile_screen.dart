import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/views/Seller_ui/auth_screen_seller/login_screen.dart';
import '../../../constant/lists.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/normal_text.dart';
import '../chat_screen_seller/messages_screen.dart';
import '../shop_seller/shop_screen.dart';
import 'editprofile_screen.dart';

class ProfileScreenSeller extends StatelessWidget {
  const ProfileScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    var authController = Get.put(AuthController());
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, size: 16.0),
        actions: [
          IconButton(
              onPressed: () {
                controller.nameController.text =
                    controller.snapshotDataSeller['vendor_name'];
                Get.to(() => const EditProfileScreenSeller());
              },
              icon: const Icon(Icons.edit)),
          TextButton(
              onPressed: () async {
                await authController.switchStatusOnline(
                    collection: vendorCollection, status: false);
                // ignore: use_build_context_synchronously
                await authController.singoutMethod(context);
                Get.offAll(() => const LoginScreenSeller());
              },
              child: normalText(text: logout)),
        ],
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getUser(vendorCollection, currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            controller.snapshotDataSeller = snapshot.data!.docs[0];
            return Column(
              children: [
                ListTile(
                  leading: controller.snapshotDataSeller['imageUrl'] == ''
                      ? Image.asset(
                          imgProduct,
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make()
                      : Image.network(
                          controller.snapshotDataSeller['imageUrl'],
                          width: 100,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
                  title: boldText(
                      text: "${controller.snapshotDataSeller['vendor_name']}"),
                  subtitle: normalText(
                      text: "${controller.snapshotDataSeller['email']}"),
                ),
                const Divider(),
                10.heightBox,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: List.generate(
                      profileButtonIcons.length,
                      (index) => ListTile(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Get.to(() => const ShopSettingsScreenSeller());
                              break;
                            case 1:
                              Get.to(() => const MessagesScreenSeller());
                          }
                        },
                        leading: Icon(
                          profileButtonIcons[index],
                          color: whiteColor,
                        ),
                        title: normalText(text: profileButtonsTitles[index]),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
