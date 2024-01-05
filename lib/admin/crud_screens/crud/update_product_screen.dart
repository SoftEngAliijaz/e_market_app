import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/firebase_services/firebase_services.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateProductScreen extends StatelessWidget {
  const UpdateProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: AppUtils.customProgressIndicator());
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No products available to Update.'),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final productData = snapshot.data!.docs[index];
                TextEditingController nameController = TextEditingController();
                TextEditingController descriptionController =
                    TextEditingController();
                TextEditingController priceController = TextEditingController();

                // Set initial values for the controllers
                nameController.text = productData['productName'];
                descriptionController.text = productData['productDescription'];
                priceController.text = productData['price'].toString();

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Center(
                          child: Text(
                            productData['id'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      title: Text(
                        productData['productName'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        productData['productDescription'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text('Update Product'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Product Name',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: descriptionController,
                                    decoration: const InputDecoration(
                                      hintText: 'Description',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Price',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    ProductModel updateProduct = ProductModel(
                                      id: productData.id,
                                      productName: nameController.text,
                                      productDescription:
                                          descriptionController.text,
                                      price: int.parse(priceController.text),
                                    );

                                    await FirebaseServices()
                                        .updateProduct(updateProduct);

                                    Navigator.pop(context);

                                    Fluttertoast.showToast(
                                      msg: 'Updated ${nameController.text}',
                                    );
                                  },
                                  child: const Text('Update'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: AppUtils.customProgressIndicator());
          }
        },
      ),
    );
  }
}
