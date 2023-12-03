import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import '../../../controllers/home_controller.dart';
import '../orders_screen_seller/orders_screen.dart';
import '../product_screen_seller/product_screen.dart';
import '../profile_screen_seller/profile_screen.dart';
import 'home_screen.dart';

class HomeSeller extends StatelessWidget {
  const HomeSeller({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var navScreens = [
      const HomeScreenSeller(),
      const ProductsScreenSeller(),
      const OrdersScreenSeller(),
      const ProfileScreenSeller(),
    ];
    var bottomNavbar = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: dashboard),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProducts,
            color: darkGrey,
            width: 24,
          ),
          label: products),
      BottomNavigationBarItem(
          icon: Image.asset(
            icOrders,
            width: 24,
            color: darkGrey,
          ),
          label: orders),
      BottomNavigationBarItem(
          icon: Image.asset(
            icGeneralSettings,
            width: 24,
            color: darkGrey,
          ),
          label: settings),
    ];
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            onTap: (index) {
              controller.currentNavIndex.value = index;
            },
            currentIndex: controller.currentNavIndex.value,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: purpleColor,
            unselectedItemColor: darkGrey,
            items: bottomNavbar),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: navScreens.elementAt(controller.currentNavIndex.value),
            )
          ],
        ),
      ),
    );
  }
}
