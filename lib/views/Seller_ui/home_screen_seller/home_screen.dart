import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/views/Seller_ui/product_screen_seller/product_details.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';

import '../../../widgets/appbar_widget.dart';
import '../../../widgets/dashboard_button.dart';
import '../../../widgets/normal_text.dart';

class HomeScreenSeller extends StatelessWidget {
  const HomeScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirestoreServices.getOrders(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return loadingIndicator(color: purpleColor);
              } else {
                var order = snapshot.data!.docs;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          dashboardButton(context,
                              title: orders,
                              count: "${order.length}",
                              icon: icOrders),
                          dashboardButton(context,
                              title: totalSales,
                              count: order.isNotEmpty
                                  ? "${order.map((orders) => orders['total_amount']).reduce((sum, orders) => sum + orders)}"
                                  : '0',
                              icon: icRefund),
                        ],
                      ),
                      10.heightBox,
                    ],
                  ),
                );
              }
            },
          ),
          StreamBuilder(
            stream: FirestoreServices.getAllProductSeller(currentUser!.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return loadingIndicator(color: purpleColor);
              } else {
                var data = snapshot.data!.docs;
                data = data
                  ..sort((a, b) =>
                      b['p_wishlist'].length.compareTo(a['p_wishlist'].length));
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          dashboardButton(context,
                              title: products,
                              count: "${data.length}",
                              icon: icProducts),
                          dashboardButton(context,
                              title: rating,
                              count: data.isNotEmpty
                                  ? "${data.map((data) => double.parse(data['p_rating'])).reduce((sum, data) => sum + data) / data.length}"
                                  : '0',
                              icon: icStar),
                        ],
                      ),
                      10.heightBox,
                      const Divider(),
                      10.heightBox,
                      boldText(text: popular, color: fontGrey, size: 16.0),
                      20.heightBox,
                      ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          data.length,
                          (index) => data[index]['p_wishlist'].length == 0
                              ? const SizedBox()
                              : ListTile(
                                  onTap: () {
                                    Get.to(() => ProductDetailsSeller(
                                          data: data[index],
                                        ));
                                  },
                                  leading: Image.network(
                                    data[index]['p_imgs'][0],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  title: boldText(
                                      text: "${data[index]['p_name']}",
                                      color: fontGrey),
                                  subtitle: normalText(
                                      text: "\$${data[index]['p_price']}",
                                      color: darkGrey),
                                ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
