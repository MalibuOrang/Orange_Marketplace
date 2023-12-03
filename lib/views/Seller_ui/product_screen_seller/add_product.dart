import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/product_controller.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../widgets/custom_textfield_seller.dart';
import '../../../widgets/normal_text.dart';
import 'components/product_dropdown.dart';
import 'components/product_images.dart';

class AddProductSeller extends StatelessWidget {
  const AddProductSeller({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return Obx(
      () => Scaffold(
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: "Add product", color: whiteColor, size: 16.0),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          actions: [
            controller.isLoading.value
                ? loadingIndicator()
                : TextButton(
                    onPressed: () async {
                      await controller.onPressSaveProductBut();
                    },
                    child: boldText(text: save, color: whiteColor))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTextFieldSeller(
                    hint: "eg. BMW",
                    title: "Product name",
                    controller: controller.pnameController),
                10.heightBox,
                customTextFieldSeller(
                    hint: "eg. Nice product",
                    title: "Description",
                    isDesc: true,
                    controller: controller.pdescController),
                10.heightBox,
                customTextFieldSeller(
                    hint: "eg. \$100",
                    title: "Price",
                    controller: controller.ppriceController),
                10.heightBox,
                customTextFieldSeller(
                    hint: "eg. 20",
                    title: "Quantity",
                    controller: controller.pquantityController),
                10.heightBox,
                productDropDown("Category", controller.categoryList,
                    controller.categoryvalue, controller),
                10.heightBox,
                productDropDown("Subcategory", controller.subcat,
                    controller.subcategoryvalue, controller),
                10.heightBox,
                const Divider(
                  color: whiteColor,
                ),
                boldText(text: "Choose produc images"),
                10.heightBox,
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                        3,
                        (index) => controller.pImagesList[index] != null
                            ? Image.file(
                                controller.pImagesList[index],
                                width: 100,
                              ).onTap(() {
                                controller.pickImage(index, context);
                              })
                            : productImages(label: "${index + 1}").onTap(() {
                                controller.pickImage(index, context);
                              })),
                  ),
                ),
                5.heightBox,
                normalText(
                    text: "First image will be your display image",
                    color: lightGrey),
                const Divider(
                  color: whiteColor,
                ),
                10.heightBox,
                boldText(text: "Choose produc colors"),
                10.heightBox,
                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      9,
                      (index) => Stack(
                        alignment: Alignment.center,
                        children: [
                          VxBox()
                              .color(Vx.randomPrimaryColor)
                              .roundedFull
                              .size(65, 65)
                              .make()
                              .onTap(() {
                            controller.selectedColorIndex.value = index;
                          }),
                          controller.selectedColorIndex.value == index
                              ? const Icon(
                                  Icons.done,
                                  color: whiteColor,
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
