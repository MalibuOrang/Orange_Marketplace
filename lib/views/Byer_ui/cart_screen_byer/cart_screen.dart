import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/cart_controller.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../widgets/our_button.dart';

class CartScreenByer extends StatelessWidget {
  const CartScreenByer({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
            color: orangeColor,
            onPress: () {
              controller.buttonFunctionProccesShopping(context);
            },
            textColor: whiteColor,
            title: "Proceed to shipping"),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            "Shoping cart".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getCart(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "Cart is empty".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              controller.calculate(data);
              controller.productSnapshot = data;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, index) {
                            return ListTile(
                              leading: Image.network(
                                "${data[index]['img']}",
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                              title:
                                  "${data[index]['title']} (x${data[index]['qty']})"
                                      .text
                                      .size(16)
                                      .fontFamily(semibold)
                                      .make(),
                              subtitle: "${data[index]['tprice']}"
                                  .numCurrency
                                  .text
                                  .color(orangeColor)
                                  .fontFamily(semibold)
                                  .make(),
                              trailing: const Icon(
                                Icons.delete,
                                color: orangeColor,
                              ).onTap(() {
                                FirestoreServices.deleteDocument(
                                    data[index].id);
                              }),
                            );
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total price"
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                        Obx(
                          () => "${controller.totalP.value}"
                              .numCurrency
                              .text
                              .fontFamily(semibold)
                              .color(orangeColor)
                              .make(),
                        )
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.all(12))
                        .color(lightGolden)
                        .width(context.screenWidth - 60)
                        .roundedSM
                        .make(),
                    10.heightBox,
                  ],
                ),
              );
            }
          }),
    );
  }
}
