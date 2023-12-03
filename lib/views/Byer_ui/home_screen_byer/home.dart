import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/controllers/home_controller.dart';
import 'package:orange_marketplace/views/Byer_ui/cart_screen_byer/cart_screen.dart';
import 'package:orange_marketplace/views/Byer_ui/category_screen_byer/category_screen.dart';
import 'package:orange_marketplace/views/Byer_ui/home_screen_byer/home_screen.dart';
import 'package:orange_marketplace/views/Byer_ui/profile_screen_byer/profile_screen.dart';
import 'package:orange_marketplace/widgets/exit_dialog.dart';

class HomeByer extends StatelessWidget {
  const HomeByer({super.key});

  @override
  Widget build(BuildContext context) {
    // init home controller
    var controller = Get.put(HomeController());
    var navbarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(
            icHome,
            width: 26,
          ),
          label: home),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCategories,
            width: 26,
          ),
          label: categories),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCart,
            width: 26,
          ),
          label: cart),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProfile,
            width: 26,
          ),
          label: account),
    ];
    var navBody = [
      const HomeScreenByer(),
      const CategoryScreenByer(),
      const CartScreenByer(),
      const ProfileScreenByer(),
    ];
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                exitDialog(context, "Are you sure you want to exit?"));
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(
              () => Expanded(
                child: navBody.elementAt(controller.currentNavIndex.value),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            selectedItemColor: orangeColor,
            selectedLabelStyle: const TextStyle(fontFamily: semibold),
            items: navbarItem,
            backgroundColor: whiteColor,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              controller.currentNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
