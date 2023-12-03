import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/controllers/product_controller.dart';
import 'package:orange_marketplace/views/Byer_ui/category_screen_byer/item_details.dart';
import 'package:orange_marketplace/widgets/bg_widget.dart';
import 'package:orange_marketplace/constant/consts.dart';

import '../../../widgets/loading_indicator.dart';

class CategoryDetailsByer extends StatefulWidget {
  final String? title;
  const CategoryDetailsByer({super.key, required this.title});

  @override
  State<CategoryDetailsByer> createState() => _CategoryDetailsByerState();
}

class _CategoryDetailsByerState extends State<CategoryDetailsByer> {
  @override
  void initState() {
    super.initState();
    ProductController().switchCategory(widget.title, productMethod);
  }

  var controller = Get.put(ProductController());
  dynamic productMethod;
  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
            appBar: AppBar(
              title: widget.title!.text.fontFamily(bold).white.make(),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        controller.subcat.length,
                        (index) => controller.subcat[index].text
                            .size(12)
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .makeCentered()
                            .box
                            .white
                            .rounded
                            .size(120, 60)
                            .margin(const EdgeInsets.symmetric(horizontal: 4))
                            .make()
                            .onTap(() {
                          controller.switchCategory(
                              controller.subcat[index], productMethod);
                          setState(() {});
                        }),
                      ),
                    ),
                  ),
                  20.heightBox,
                  StreamBuilder(
                    stream: productMethod,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(
                          child: Center(
                            child: loadingIndicator(),
                          ),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Expanded(
                          child: "No products found!"
                              .text
                              .color(darkFontGrey)
                              .makeCentered(),
                        );
                      } else {
                        var data = snapshot.data!.docs;
                        return Expanded(
                            child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 250,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8),
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        data[index]['p_imgs'][0],
                                        height: 150,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      "${data[index]['p_name']}"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      10.heightBox,
                                      "${data[index]['p_price']}"
                                          .numCurrency
                                          .text
                                          .color(orangeColor)
                                          .fontFamily(bold)
                                          .size(16)
                                          .make(),
                                      10.heightBox,
                                    ],
                                  )
                                      .box
                                      .white
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .roundedSM
                                      .outerShadowSm
                                      .padding(const EdgeInsets.all(12))
                                      .make()
                                      .onTap(() {
                                    controller.checkIfFav(data[index]);
                                    Get.to(
                                      () => ItemDetailsByer(
                                        title: "${data[index]['p_name']}",
                                        data: data[index],
                                      ),
                                    );
                                  });
                                }));
                      }
                    },
                  ),
                ],
              ),
            )));
  }
}
