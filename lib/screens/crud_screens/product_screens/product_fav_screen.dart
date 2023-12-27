import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopbiz_app/models/product_model/product_model.dart';

class ProductFavScreen extends StatelessWidget {
  const ProductFavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fav Products'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('favorites').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Loading indicator while data is being fetched
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // Check if there are no documents in the collection
            if (snapshot.data?.docs.isEmpty ?? true) {
              return Center(
                child: Text('No favorite products available.'),
              );
            }

            // Extract the list of products from the snapshot
            List<ProductModel> favoriteProducts = snapshot.data!.docs
                .map((doc) =>
                    ProductModel.fromJson(doc.data() as Map<String, dynamic>))
                .toList();

            return ListView.builder(
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final value = favoriteProducts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(value.imageUrl),
                  ),
                  title: Text(value.name),
                  subtitle: Text(value.description),
                );
              },
            );
          },
        ));
  }
}
