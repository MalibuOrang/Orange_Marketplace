import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/cart_controller.dart';
import 'package:orange_marketplace/views/Byer_ui/cart_screen_byer/payment_method.dart';
import 'package:orange_marketplace/widgets/custom_textfield_byer.dart';
import 'package:orange_marketplace/widgets/our_button.dart';

class ShopingDetailsByer extends StatefulWidget {
  const ShopingDetailsByer({super.key});

  @override
  State<ShopingDetailsByer> createState() => _ShopingDetailsByerState();
}

class _ShopingDetailsByerState extends State<ShopingDetailsByer> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info".text.fontFamily(semibold).color(fontGrey).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () async {
            controller.onPressContinueButton(context,
                screan: const PaymentMethodsByer());
          },
          color: orangeColor,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextFieldByer(
                hint: "Address",
                isPass: false,
                title: "Address",
                controller: controller.addressController),
            20.heightBox,
            CSCPicker(
              layout: Layout.vertical,
              onCountryChanged: (country) {
                controller.country = country;
              },
              onStateChanged: (state) {
                controller.state = state;
              },
              onCityChanged: (city) {
                controller.city = city;
              },
            ),
            20.heightBox,
            customTextFieldByer(
                hint: "Postal code",
                isPass: false,
                title: "Postal code",
                controller: controller.postalCodeController),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Phone"
                    .text
                    .color(Vx.orange500)
                    .fontFamily(semibold)
                    .size(16)
                    .make(),
                5.heightBox,
                IntlPhoneField(
                  autofocus: true,
                  languageCode: 'en',
                  obscureText: false,
                  controller: controller.phoneNumberController,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontFamily: semibold,
                      color: textfieldGrey,
                    ),
                    hintText: "Phone number",
                    isDense: true,
                    fillColor: lightGrey,
                    filled: true,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: orangeColor,
                    )),
                  ),
                  onCountryChanged: (country) {
                    controller.contryCode = country.fullCountryCode;
                  },
                ),
                5.heightBox
              ],
            ),
          ],
        ),
      ),
    );
  }
}
