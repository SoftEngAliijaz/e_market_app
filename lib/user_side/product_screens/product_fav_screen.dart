import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFavScreen extends StatelessWidget {
  const ProductFavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator while data is being fetched
            return Center(child: AppUtils.customProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Check if there are no documents in the collection
          final favoriteProducts = snapshot.data?.docs
              .map((doc) =>
                  ProductModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          if (favoriteProducts == null || favoriteProducts.isEmpty) {
            return const Center(child: Text('No favorite products available.'));
          }

          return ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];
              // Use the first image URL if available
              final imageUrl = product.imageUrls?.isNotEmpty ?? false
                  ? product.imageUrls![0]
                  : ''; // You might want to provide a default URL or handle this case differently
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(imageUrl),
                ),
                title: Text(product.productName ?? ''),
                subtitle: Text(product.productDescription ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
