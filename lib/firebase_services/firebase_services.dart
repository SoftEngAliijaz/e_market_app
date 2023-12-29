import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/models/product_model/product_model.dart';

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'products';

  // Create a new product
  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection(_collectionName).add(product.toJson());
  }

  // Get a list of all products
  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(_collectionName).get();

    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Get a single product by ID
  Future<ProductModel?> getProductById(String productId) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(_collectionName).doc(productId).get();

    if (documentSnapshot.exists) {
      return ProductModel.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  // Update a product
  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection(_collectionName)
        .doc(product.id)
        .update(product.toJson());
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection(_collectionName).doc(productId).delete();
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'products';

  // Create a new product (admin only)
  Future<void> addProduct(ProductModel product) async {
    if (isAdmin()) {
      await _firestore.collection(_collectionName).add(product.toJson());
    } else {
      // Handle non-admin user trying to add product
      // You can show an error message or perform other actions here
    }
  }

  // Update a product (admin only)
  Future<void> updateProduct(ProductModel product) async {
    if (isAdmin()) {
      await _firestore.collection(_collectionName).doc(product.id).update(product.toJson());
    } else {
      // Handle non-admin user trying to update product
      // You can show an error message or perform other actions here
    }
  }

  // Delete a product (admin only)
  Future<void> deleteProduct(String productId) async {
    if (isAdmin()) {
      await _firestore.collection(_collectionName).doc(productId).delete();
    } else {
      // Handle non-admin user trying to delete product
      // You can show an error message or perform other actions here
    }
  }

  // Helper method to check if the current user is an admin
  bool isAdmin() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Add your logic to determine if the user is an admin based on user data
      // For example, you can check a field like 'isAdmin' in the user document
      // or use a dedicated 'admins' collection in Firestore
      // For demonstration purposes, let's assume there is a field 'isAdmin' in the user document
      return currentUser.uid == 'your_admin_uid' && currentUser.email == 'admin@example.com';
    }
    return false;
  }

  // Get a list of all products (accessible to all users)
  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot querySnapshot = await _firestore.collection(_collectionName).get();

    return querySnapshot.docs.map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  // Get a single product by ID (accessible to all users)
  Future<ProductModel?> getProductById(String productId) async {
    DocumentSnapshot documentSnapshot = await _firestore.collection(_collectionName).doc(productId).get();

    if (documentSnapshot.exists) {
      return ProductModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
 */