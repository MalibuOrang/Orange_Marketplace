import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';

class WishlistScreenByer extends StatelessWidget {
  const WishlistScreenByer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlist(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No wishlist yet!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Image.network(
                    "${data[index]['p_imgs'][0]}",
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  title: "${data[index]['p_name']}"
                      .text
                      .size(16)
                      .fontFamily(semibold)
                      .make(),
                  subtitle: "${data[index]['p_price']}"
                      .numCurrency
                      .text
                      .color(orangeColor)
                      .fontFamily(semibold)
                      .make(),
                  trailing: const Icon(
                    Icons.favorite,
                    color: orangeColor,
                  ).onTap(() async {
                    firestore
                        .collection(productsCollection)
                        .doc(data[index].id)
                        .set({
                      'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
                    }, SetOptions(merge: true));
                  }),
                );
              },
            );
          }
        },
      ),
    );
  }
}
