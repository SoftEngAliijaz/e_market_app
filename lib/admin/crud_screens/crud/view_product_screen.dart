import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:flutter/material.dart';

class ViewProductScreen extends StatelessWidget {
  const ViewProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.hasData) {
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No products available'));
            } else {
              return ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final productData = snapshot.data!.docs[index];

                  return SizedBox(
                    child: _productCard(ProductModel.fromJson(
                        productData.data() as Map<String, dynamic>)),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            }
          } else {
            return Center(child: AppUtils.customProgressIndicator());
          }
        },
      ),
    );
  }

  Card _productCard(ProductModel product) {
    return Card(
      color: Colors.white,
      child: Container(
        height: 300,
        width: 300,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: product.imageUrls != null &&
                        product.imageUrls!.isNotEmpty
                    ? Image.network(
                        product.imageUrls![0], // Assuming the first image URL
                        fit: BoxFit.contain,
                        width: double.infinity,
                      )
                    : Center(child: Text('No Image')),
              ),
            ),
            Divider(),
            ListTile(
              tileColor: Colors.white,
              leading: CircleAvatar(
                child: Center(
                  child: Text(
                    product.id!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              title: Text(product.productName!),
              subtitle: Text(product.productDescription!),
              trailing: Text("Price: ${product.price}"),
            ),
          ],
        ),
      ),
    );
  }
}
