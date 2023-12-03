import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/product_controller.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../constant/lists.dart';
import '../../../widgets/appbar_widget.dart';
import '../../../widgets/normal_text.dart';
import 'add_product.dart';
import 'product_details.dart';

class ProductsScreenSeller extends StatelessWidget {
  const ProductsScreenSeller({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return Scaffold(
      backgroundColor: whiteColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleColor,
        onPressed: () async {
          await controller.onPressAddProductSellerBut(const AddProductSeller());
        },
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget(products),
      body: StreamBuilder(
        stream: FirestoreServices.getAllProductSeller(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(color: purpleColor);
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) => ListTile(
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
                          text: "${data[index]['p_name']}", color: fontGrey),
                      subtitle: Row(
                        children: [
                          normalText(
                              text: "\$${data[index]['p_price']}",
                              color: darkGrey),
                          10.widthBox,
                          boldText(
                              text: data[index]['is_featured'] == true
                                  ? "Featured"
                                  : "",
                              color: green)
                        ],
                      ),
                      trailing: VxPopupMenu(
                        arrowSize: 0.0,
                        menuBuilder: () => Column(
                          children: List.generate(
                            popupMenuTitles.length,
                            (i) => Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    popupMenuIcons[i],
                                    color: data[index]['featured_id'] ==
                                                currentUser!.uid &&
                                            i == 0
                                        ? green
                                        : darkGrey,
                                  ),
                                  10.widthBox,
                                  normalText(
                                      text: data[index]['featured_id'] ==
                                                  currentUser!.uid &&
                                              i == 0
                                          ? 'Remove feature'
                                          : popupMenuTitles[i],
                                      color: darkGrey),
                                ],
                              ).onTap(() async {
                                await controller.onPressProductMenuBut(
                                    i, data, context);
                              }),
                            ),
                          ),
                        ).box.white.width(200).rounded.make(),
                        clickType: VxClickType.singleClick,
                        child: const Icon(Icons.more_vert_rounded),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
