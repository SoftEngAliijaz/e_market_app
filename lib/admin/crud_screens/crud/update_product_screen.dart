import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/firebase_services/firebase_services.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  @override
  Widget build(BuildContext context) {
    final String _collection = 'products';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(_collection).snapshots(),
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
                ///value
                final productData = snapshot.data!.docs[index];

                ///TextEditingController
                TextEditingController idController = TextEditingController();
                TextEditingController nameController = TextEditingController();
                TextEditingController descriptionController =
                    TextEditingController();
                TextEditingController priceController = TextEditingController();
                TextEditingController discountController =
                    TextEditingController();
                TextEditingController serialCodeController =
                    TextEditingController();
                TextEditingController productBrandController =
                    TextEditingController();

                // Set initial values for the controllers
                idController.text = productData['id'];
                nameController.text = productData['productName'];
                descriptionController.text = productData['productDescription'];
                priceController.text = productData['price'].toString();
                discountController.text =
                    productData['discountPrice'].toString();
                serialCodeController.text = productData['serialCode'];
                productBrandController.text = productData['brand'];

                return Card(
                  elevation: 5.0,
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Product Name',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: descriptionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Product Description',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Product Price',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: discountController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Product Discount',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: serialCodeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Serial Code',
                                    ),
                                  ),
                                  TextFormField(
                                    controller: productBrandController,
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Brand',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              MaterialButton(
                                shape: StadiumBorder(),
                                color: Colors.red,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              MaterialButton(
                                shape: StadiumBorder(),
                                color: Colors.green,
                                onPressed: () async {
                                  ProductModel updateProduct = ProductModel(
                                    id: productData.id,
                                    productName: nameController.text,
                                    productDescription:
                                        descriptionController.text,
                                    price: int.parse(priceController.text),
                                    discountPrice:
                                        int.parse(discountController.text),
                                    serialCode: serialCodeController.text,
                                    brand: productBrandController.text,
                                  );

                                  await FirebaseServices()
                                      .updateProduct(updateProduct);

                                  Navigator.pop(context);

                                  Fluttertoast.showToast(
                                    msg: 'Updated ${nameController.text}',
                                  );
                                },
                                child: const Text(
                                  'Update',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
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
