import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/constant/lists.dart';
import 'package:orange_marketplace/controllers/auth_controller.dart';
import 'package:orange_marketplace/views/Byer_ui/auth_screen_byer/login_screen.dart';
import 'package:orange_marketplace/views/Byer_ui/chat_screen_byer/messaging_screen.dart';
import 'package:orange_marketplace/views/Byer_ui/orders_screen_byer/orders_screen.dart';
import 'package:orange_marketplace/views/Byer_ui/profile_screen_byer/components/details_cart.dart';
import 'package:orange_marketplace/views/Byer_ui/profile_screen_byer/edit_profile_screen.dart';
import 'package:orange_marketplace/views/Byer_ui/wishlist_screen_byer/wishlist_screen.dart';
import 'package:orange_marketplace/widgets/bg_widget.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';

import '../../../controllers/profile_controller.dart';
import '../../../services/firestore_services.dart';

class ProfileScreenByer extends StatelessWidget {
  const ProfileScreenByer({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    var authController = Get.put(AuthController());
    return bgWidget(
      child: Scaffold(
          body: StreamBuilder(
              stream:
                  FirestoreServices.getUser(userCollection, currentUser!.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return loadingIndicator();
                } else {
                  controller.snapshotDataByer = snapshot.data!.docs[0];
                  return SafeArea(
                      child: Column(
                    children: [
                      // edit profile button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.edit,
                            color: whiteColor,
                          ),
                        ).onTap(() {
                          controller.nameController.text =
                              controller.snapshotDataByer['name'];

                          Get.to(() => EditProfileScreenByer(
                              data: controller.snapshotDataByer));
                        }),
                      ),
                      // users details section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            controller.snapshotDataByer['imageUrl'] == ''
                                ? Image.asset(
                                    imgProfile,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ).box.roundedFull.clip(Clip.antiAlias).make()
                                : Image.network(
                                    controller.snapshotDataByer['imageUrl'],
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ).box.roundedFull.clip(Clip.antiAlias).make(),
                            10.widthBox,
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${controller.snapshotDataByer['name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .white
                                    .make(),
                                "${controller.snapshotDataByer['email']}"
                                    .text
                                    .white
                                    .make()
                              ],
                            )),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                  color: whiteColor,
                                )),
                                onPressed: () async {
                                  await authController.switchStatusOnline(
                                      collection: userCollection,
                                      status: false);
                                  // ignore: use_build_context_synchronously
                                  await authController.singoutMethod(context);
                                  Get.offAll(() => const LoginScreenByer());
                                },
                                child: logout.text
                                    .fontFamily(semibold)
                                    .white
                                    .make())
                          ],
                        ),
                      ),
                      10.heightBox,
                      FutureBuilder(
                        future: FirestoreServices.getCounts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: loadingIndicator());
                          } else {
                            var countData = snapshot.data;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                detailsCard(
                                    count: countData[0].toString(),
                                    title: "in your cart",
                                    width: context.screenWidth / 3.5),
                                detailsCard(
                                    count: countData[1].toString(),
                                    title: "in your wishlist",
                                    width: context.screenWidth / 3.5),
                                detailsCard(
                                    count: countData[2].toString(),
                                    title: "your orders",
                                    width: context.screenWidth / 3.5),
                              ],
                            );
                          }
                        },
                      ),

                      5.heightBox,
                      //Row buttons section
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: profileButtonList.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          color: lightGrey,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Get.to(() => const OrdersScreenByer());
                                  break;
                                case 1:
                                  Get.to(() => const WishlistScreenByer());
                                  break;
                                case 2:
                                  Get.to(() => const MessagesScreenByer());
                                  break;
                              }
                            },
                            leading: Image.asset(
                              profileButtonIcon[index],
                              width: 22,
                            ),
                            title: profileButtonList[index]
                                .text
                                .fontFamily(semibold)
                                .color(darkFontGrey)
                                .make(),
                          );
                        },
                      )
                          .box
                          .white
                          .rounded
                          .margin(const EdgeInsets.all(12))
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .shadowSm
                          .make()
                          .box
                          .color(profileColor)
                          .make(),
                    ],
                  ));
                }
              })),
    );
  }
}
