import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/views/Byer_ui/orders_screen_byer/orders_details.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';

class OrdersScreenByer extends StatelessWidget {
  const OrdersScreenByer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No ordes yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: "${index + 1}".text.color(darkFontGrey).xl.make(),
                  title: data[index]['order_code']
                      .toString()
                      .text
                      .color(orangeColor)
                      .fontFamily(semibold)
                      .make(),
                  subtitle: data[index]['total_amount']
                      .toString()
                      .numCurrency
                      .text
                      .fontFamily(bold)
                      .make(),
                  trailing: IconButton(
                    onPressed: () {
                      Get.to(() => OrderDetailsByer(
                            data: data[index],
                          ));
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    color: darkFontGrey,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
