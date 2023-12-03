import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/models/category_model.dart';
import 'package:path/path.dart';

import '../services/firestore_services.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  //subcategory list
  var subcat = <String>[].obs;
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  int index = 0;
  var isFav = false.obs;
  //text field controller
  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();
  //category list
  var categoryList = <String>[].obs;
  List<Category> category = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>.generate(3, (index) => null);
  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  var selectedColorIndex = 0.obs;
  sellerProduct(uid) => firestore
      .collection(productsCollection)
      .where('vendor_id', isEqualTo: uid)
      .snapshots();
  getCategoryList() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decode = categoryModelFromJson(data);
    category = decode.categories;
  }

  switchCategory(title, productMethod) {
    if (subcat.contains(title)) {
      productMethod = FirestoreServices.getSubcategoryProducts(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  populateCategoryList() {
    categoryList.clear();
    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImages() async {
    pImagesLinks.clear();
    for (var item in pImagesList) {
      if (item != null) {
        var filename = basename(item.path);
        var destination = 'images/vendors/${currentUser!.uid}/$filename';
        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(File(item.path));
        var n = await ref.getDownloadURL();
        pImagesLinks.add(n);
      }
    }
  }

  uploadProduct(context) async {
    var store = firestore.collection(productsCollection).doc();
    await store.set({
      'is_featured': false,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_colors': FieldValue.arrayUnion([Colors.red.value, Colors.brown.value]),
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_seller': username,
      'p_rating': '5.0',
      'vendor_id': currentUser!.uid,
      'vendor_token': userToken,
      'featured_id': '',
    });
    isLoading(false);
    VxToast.show(context, msg: "Product uploaded successfully");
  }

  addFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  removeProduct(docId) async {
    await firestore.collection(productsCollection).doc(docId).delete();
  }

  getSubCategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s =
        decoded.categories.where((element) => element.name == title).toList();
    for (var e in s[index].subcategory) {
      subcat.add(e);
    }
  }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity.value++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
    }
  }

  calculateTotalPrice(price) {
    totalPrice.value = price * quantity.value;
  }

  addToCard(
      {context,
      title,
      img,
      sellername,
      color,
      qty,
      tprice,
      vendorID,
      userToken}) async {
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'color': color,
      'qty': qty,
      'tprice': tprice,
      'added_by': currentUser!.uid,
      'vendor_id': vendorID,
      'user_token': userToken
    }).catchError((error) {
      VxToast.show(context, msg: error.toString());
    });
  }

  resetValues() {
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Add to favourite");
  }

  removeFromWishlist(docId, context) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Remove favourite");
  }

  checkIfFav(data) async {
    if (data['p_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }

  onPressFavouriteProduct(data) async {
    if (isFav.value) {
      await removeFromWishlist(data.id, context);
    } else {
      await addToWishlist(data.id, context);
    }
  }

  onPressIncreaseProduct(data) {
    increaseQuantity(int.parse(data['p_quantity']));
    calculateTotalPrice(int.parse(data['p_price']));
  }

  onPressDecreaseProduct(data) {
    decreaseQuantity();
    calculateTotalPrice(int.parse(data['p_price']));
  }

  onPressAddProductBut(context, data) async {
    if (quantity.value == 0) {
      VxToast.show(context, msg: "Choose at-least one product to add to cart");
    } else {
      await addToCard(
        context: context,
        color: data['p_colors'][colorIndex.value],
        img: data['p_imgs'][0],
        qty: quantity.value,
        sellername: data['p_seller'],
        title: data['p_name'],
        vendorID: data['vendor_id'],
        userToken: data['user_token'],
        tprice: totalPrice.value,
      );
      VxToast.show(context, msg: "Added to cart");
    }
  }

  onPressSaveProductBut() async {
    isLoading(true);
    await uploadImages();
    await uploadProduct(context);
    Get.back();
  }

  onPressProductMenuBut(int i, data, context) async {
    switch (i) {
      case 0:
        if (data[index]['is_featured'] == true) {
          await removeFeatured(data[index].id);
          VxToast.show(context, msg: "Removed");
        } else {
          await addFeatured(data[index].id);
          VxToast.show(context, msg: "Added");
        }
        break;
      case 1:
        await removeProduct(data[index].id);
        VxToast.show(context, msg: "Product removed");
        break;
    }
  }

  onPressAddProductSellerBut(Widget screan) async {
    await getCategoryList();
    populateCategoryList();
    Get.to(() => screan);
  }
}
