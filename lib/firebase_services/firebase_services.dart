import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:e_market_app/constants/db_collections.dart' as collections;
import 'package:e_market_app/models/product_model/product_model.dart' as model;

class FirebaseServices {
  // Create a new product
  Future<void> addProduct(model.ProductModel product) async {
    await cloud_firestore.FirebaseFirestore.instance
        .collection(collections.DatabaseCollection.productCollection)
        .add(product.toJson());
  }

  // Get a list of all products
  Future<List<model.ProductModel>> getProducts() async {
    cloud_firestore.QuerySnapshot querySnapshot = await cloud_firestore
        .FirebaseFirestore.instance
        .collection(collections.DatabaseCollection.productCollection)
        .get();

    return querySnapshot.docs
        .map((doc) =>
            model.ProductModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Get a single product by ID
  Future<model.ProductModel?> getProductById(String productId) async {
    cloud_firestore.DocumentSnapshot documentSnapshot = await cloud_firestore
        .FirebaseFirestore.instance
        .collection(collections.DatabaseCollection.productCollection)
        .doc(productId)
        .get();

    if (documentSnapshot.exists) {
      return model.ProductModel.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  // Update a product
  Future<void> updateProduct(model.ProductModel product) async {
    await cloud_firestore.FirebaseFirestore.instance
        .collection(collections.DatabaseCollection.productCollection)
        .doc(product.id)
        .update(product.toJson());
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    await cloud_firestore.FirebaseFirestore.instance
        .collection(collections.DatabaseCollection.productCollection)
        .doc(productId)
        .delete();
  }
}
