import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/constants/db_collections.dart';
import 'package:e_market_app/firebase_services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteProductScreen extends StatelessWidget {
  const DeleteProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(DatabaseCollection.productCollection)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: AppUtils.customProgressIndicator());
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No products available to Delete.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final productData = snapshot.data!.docs[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Center(
                          child: Text(
                        productData['id'],
                        overflow: TextOverflow.ellipsis,
                      )),
                    ),
                    title: Text(productData['productName']),
                    subtitle: Text(productData['productDescription']),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            final delInfo = productData['productName'];
                            return AlertDialog(
                              title: Text('Are You Sure?'),
                              content:
                                  Text('Do you want to delete this product?'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseServices()
                                        .deleteProduct(productData.id)
                                        .whenComplete(
                                          () => Navigator.pop(context),
                                        )
                                        .then((value) => Fluttertoast.showToast(
                                            msg: 'Deleted: $delInfo'));
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
