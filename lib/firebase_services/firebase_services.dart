import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/db_collections.dart';
import 'package:e_market_app/models/product_model/product_model.dart';

class FirebaseServices {
  // Create a new product
  Future<void> addProduct(ProductModel product) async {
    await FirebaseFirestore.instance
        .collection(DatabaseCollection.productCollection)
        .add(product.toJson());
  }

  // Get a list of all products
  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(DatabaseCollection.productCollection)
        .get();

    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Get a single product by ID
  Future<ProductModel?> getProductById(String productId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(DatabaseCollection.productCollection)
        .doc(productId)
        .get();

    if (documentSnapshot.exists) {
      return ProductModel.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  // Update a product
  Future<void> updateProduct(ProductModel product) async {
    await FirebaseFirestore.instance
        .collection(DatabaseCollection.productCollection)
        .doc(product.id)
        .update(product.toJson());
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection(DatabaseCollection.productCollection)
        .doc(productId)
        .delete();
  }
}
