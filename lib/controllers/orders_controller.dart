import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';

class OrdersController extends GetxController {
  var orders = [];
  RxBool confirmed = false.obs;
  RxBool ondelivery = false.obs;
  RxBool delivered = false.obs;
  getOrdersSeller(data) {
    orders.clear();
    for (var item in data['orders']) {
      if (item['vendor_id'] == currentUser!.uid) {
        orders.add(item);
      }
    }
  }

  changeStatus(title, status, docID) async {
    var store = firestore.collection(ordersCollection).doc(docID);
    await store.set({title: status}, SetOptions(merge: true));
  }
}
