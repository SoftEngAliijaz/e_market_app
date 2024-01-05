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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_market_app/models/product_model/product_model.dart';

// class FirebaseServices {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _collectionName = 'products';

//   // Create a new product
//   Future<void> addProduct(ProductModel product) async {
//     await _firestore.collection(_collectionName).add(product.toJson());
//   }

//   // Get a list of all products
//   Future<List<ProductModel>> getProducts() async {
//     QuerySnapshot querySnapshot =
//         await _firestore.collection(_collectionName).get();

//     return querySnapshot.docs
//         .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
//         .toList();
//   }

//   // Get a single product by ID
//   Future<ProductModel?> getProductById(String productId) async {
//     DocumentSnapshot documentSnapshot =
//         await _firestore.collection(_collectionName).doc(productId).get();

//     if (documentSnapshot.exists) {
//       return ProductModel.fromJson(
//           documentSnapshot.data() as Map<String, dynamic>);
//     } else {
//       return null;
//     }
//   }

//   // Update a product
//   Future<void> updateProduct(ProductModel product) async {
//     await _firestore
//         .collection(_collectionName)
//         .doc(product.id)
//         .update(product.toJson());
//   }

//   // Delete a product
//   Future<void> deleteProduct(String productId) async {
//     await _firestore.collection(_collectionName).doc(productId).delete();
//   }
// }
