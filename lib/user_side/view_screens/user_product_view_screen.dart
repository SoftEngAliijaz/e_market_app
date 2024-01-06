import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:e_market_app/user_side/product_screens/product_detail_screens.dart';
import 'package:flutter/material.dart';

class UserProductViewScreen extends StatelessWidget {
  const UserProductViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Product View Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.hasData) {
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No products available'));
            } else {
              return ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final productData = snapshot.data!.docs[index];
                  final product = ProductModel.fromJson(
                      productData.data() as Map<String, dynamic>);

                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ProductDetailScreen(product: product);
                      }));
                    },
                    child: _productCard(product),
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
                child: Image.network(
                  product
                      .imageUrls![0], // Use a default value or handle null case
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
            const Divider(),
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
              title: Text(product.productName ?? ''),
              subtitle: Text(product.productDescription ?? ''),
              trailing: Text("Price: ${product.price}"),
            ),
          ],
        ),
      ),
    );
  }
}
