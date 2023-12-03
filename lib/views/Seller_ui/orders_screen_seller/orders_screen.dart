import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../widgets/appbar_widget.dart';
import '../../../widgets/normal_text.dart';
import 'order_details.dart';

class OrdersScreenSeller extends StatelessWidget {
  const OrdersScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: appbarWidget(orders),
      body: StreamBuilder(
        stream: FirestoreServices.getOrders(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else if (snapshot.data!.docs.isEmpty) {
            return "No ordes yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var orderData = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(orderData.length, (index) {
                    var time = orderData[index]['order_date'].toDate();
                    return ListTile(
                      onTap: () {
                        Get.to(() => OrderDetailsSeller(
                              data: orderData[index],
                            ));
                      },
                      tileColor: textfieldGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: boldText(
                          text: "${orderData[index]['order_code']}",
                          color: purpleColor),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: fontGrey,
                              ),
                              10.widthBox,
                              boldText(
                                  text:
                                      intl.DateFormat().add_yMd().format(time),
                                  color: fontGrey),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.payment,
                                color: fontGrey,
                              ),
                              10.widthBox,
                              boldText(text: unpaid, color: red),
                            ],
                          )
                        ],
                      ),
                      trailing: boldText(
                          text: "\$ ${orderData[index]['total_amount']}",
                          color: purpleColor,
                          size: 16.0),
                    ).box.margin(const EdgeInsets.only(bottom: 4)).make();
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
