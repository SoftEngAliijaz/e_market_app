import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/constants/db_collections.dart';
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
        stream: FirebaseFirestore.instance
            .collection(DatabaseCollection.productCollection)
            .snapshots(),
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

                  return _productCard(
                    context,
                    ProductModel.fromJson(
                      productData.data() as Map<String, dynamic>,
                    ),
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

  Widget _productCard(
    BuildContext context,
    ProductModel product,
  ) {
    final Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Container(
        height: 300,
        width: size.width,
        child: Column(
          children: [
            if (product.imageUrls != null && product.imageUrls!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: product.imageUrls!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(5.0),
                      child: Image.network(
                        product.imageUrls![index],
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
            ListTile(
              tileColor: Colors.white,
              leading: CircleAvatar(
                child: Center(
                  child: Text(
                    product.id ?? "N/A",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              title: Text(product.productName ?? "N/A"),
              subtitle: Text(product.productDescription ?? "N/A"),
              trailing: Text("Price: ${product.price ?? "N/A"}"),
            ),
          ],
        ),
      ),
    );
  }
}
