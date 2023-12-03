import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/constant/lists.dart';
import 'package:orange_marketplace/controllers/cart_controller.dart';
import 'package:orange_marketplace/controllers/payment_controller.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';
import '../../../widgets/our_button.dart';

class PaymentMethodsByer extends StatefulWidget {
  const PaymentMethodsByer({super.key});

  @override
  State<PaymentMethodsByer> createState() => _PaymentMethodsByerState();
}

class _PaymentMethodsByerState extends State<PaymentMethodsByer> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    var paymentController = Get.put(PaymentController());
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: "Choose Payment Method"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(
                  child: loadingIndicator(),
                )
              : ourButton(
                  onPress: () async {
                    paymentController.onPressPaymentButton(controller, context);
                  },
                  color: orangeColor,
                  textColor: whiteColor,
                  title: "Make Payment",
                ),
        ),
        body: PopScope(
          canPop: false,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Obx(
              () => Column(
                children: List.generate(paymentMethodImg.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      paymentController.paymentIndex(index);
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: orangeColor,
                            width: 4,
                          )),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.asset(
                            paymentMethodImg[index],
                            width: double.infinity,
                            height: 120,
                            color: paymentController.paymentIndex.value == index
                                ? Colors.black.withOpacity(0.4)
                                : Colors.transparent,
                            colorBlendMode:
                                paymentController.paymentIndex.value == index
                                    ? BlendMode.darken
                                    : BlendMode.color,
                            fit: BoxFit.cover,
                          ),
                          paymentController.paymentIndex.value == index
                              ? Transform.scale(
                                  scale: 1.3,
                                  child: Checkbox(
                                      activeColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      value: true,
                                      onChanged: (value) {}),
                                )
                              : Container(),
                          Positioned(
                              bottom: 0,
                              right: 10,
                              child: paymentMethods[index]
                                  .text
                                  .white
                                  .fontFamily(semibold)
                                  .size(16)
                                  .make()),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
