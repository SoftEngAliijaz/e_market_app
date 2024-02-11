import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/db_collections.dart';
import 'package:flutter/cupertino.dart';

class CartModel {
  String? id;
  String? name;
  int? quantity;
  int? price;
  String? image;

  CartModel({
    @required this.id,
    @required this.image,
    @required this.name,
    @required this.price,
    this.quantity,
  });

  static Future<void> addtoCart(CartModel cart) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection(DatabaseCollection.cartCollection);
    Map<String, dynamic> data = {
      "id": cart.id,
      "productName": cart.name,
      "image": cart.image,
      "quantity": cart.quantity,
      "price": cart.price,
    };
    await collectionReference.add(data);
  }
}
