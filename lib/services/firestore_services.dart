import 'dart:developer';
import 'package:orange_marketplace/constant/consts.dart';

class FirestoreServices {
  //get users data
  static getUser(clientCollection, uid) {
    return firestore
        .collection(clientCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  // get push token
  static Future<String?> getMessagesToken() async {
    await fMmessaging.requestPermission();
    try {
      String? userToken = await fMmessaging.getToken();
      if (userToken != null) {
        log(userToken);
        return userToken;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  //get products according to category
  static getProducts(category) {
    return firestore
        .collection(productsCollection)
        .where('p_category', isEqualTo: category)
        .snapshots();
  }

  static getSubcategoryProducts(title) {
    return firestore
        .collection(productsCollection)
        .where('p_subcategory', isEqualTo: title)
        .snapshots();
  }

// get cart
  static getCart(uid) {
    return firestore
        .collection(cartCollection)
        .where('added_by', isEqualTo: uid)
        .snapshots();
  }

  // delete document
  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  // get all chat messages
  static getChatMessages(docId) {
    return firestore
        .collection(chatCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  // get all orders
  static getAllOrders() {
    return firestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  // get all wishlist
  static getWishlist() {
    return firestore
        .collection(productsCollection)
        .where('p_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  // get all chat messages
  static getAllMessages() {
    return firestore
        .collection(chatCollection)
        .where('users', arrayContains: currentUser!.uid)
        .snapshots();
  }

  // delete messages from chat collection
  static deleteMesFromChat(chatId, mesId) {
    return firestore
        .collection(chatCollection)
        .doc(chatId)
        .collection(messagesCollection)
        .doc(mesId)
        .delete();
  }

  //delete chat collection
  static deleteChat(docId) {
    return firestore.collection(chatCollection).doc(docId).delete();
  }

  static updateLastMsg(currentDocId) async {
    var latestMessage = await firestore
        .collection(chatCollection)
        .doc(currentDocId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: true)
        .limit(1)
        .get();

    if (latestMessage.docs.isNotEmpty) {
      var lastMsgText = latestMessage.docs[0]['msg'];
      await firestore.collection(chatCollection).doc(currentDocId).update({
        'last_msg': lastMsgText,
      });
    } else {
      await firestore.collection(chatCollection).doc(currentDocId).update({
        'last_msg': "",
      });
    }
  }

  static getCounts() async {
    var res = await Future.wait([
      firestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(productsCollection)
          .where('p_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
      firestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }

  static allProduct() {
    return firestore.collection(productsCollection).snapshots();
  }

  //get featured product method
  static getFeaturedProducts() {
    return firestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  static searchProducts(title) {
    return firestore
        .collection(productsCollection)
        .where('p_name', isLessThanOrEqualTo: title)
        .get();
  }

  // get all orders for sellings
  static getOrders(uid) {
    return firestore
        .collection(ordersCollection)
        .where('vendors', arrayContains: uid)
        .snapshots();
  }

  static getAllProductSeller(uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }
}
