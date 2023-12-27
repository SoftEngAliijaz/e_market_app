import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopbiz_app/constants/constants.dart';

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
                nameController.text = productData['name'];
                descriptionController.text = productData['description'];
                priceController.text = productData['price'].toString();

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: CircleAvatar(
                          child: Center(child: Text(productData['id']))),
                      title: Text(productData['name']),
                      subtitle: Text(productData['description']),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text('Update Product'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      hintText: "Product Name",
                                    ),
                                  ),
                                  TextFormField(
                                    controller: descriptionController,
                                    decoration: InputDecoration(
                                      hintText: "Description",
                                    ),
                                  ),
                                  TextFormField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Price",
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(productData.id)
                                        .update({
                                          'name': nameController.text,
                                          'description':
                                              descriptionController.text,
                                          'price': double.parse(
                                              priceController.text),
                                        })
                                        .whenComplete(
                                            () => Navigator.pop(context))
                                        .then((value) => Fluttertoast.showToast(
                                            msg:
                                                'Updated ${nameController.text}'));
                                  },
                                  child: Text("Update"),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shopbiz_app/constants/constants.dart';

// class UpdateProductScreen extends StatelessWidget {
//   const UpdateProductScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Products'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('products').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: AppUtils.customProgressIndicator());
//           }
//           if (!snapshot.hasData ||
//               snapshot.data == null ||
//               snapshot.data!.docs.isEmpty) {
//             // Display a message if there is no data
//             return const Center(
//                 child: Text('No products available to Delete.'));
//           }
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final productData = snapshot.data!.docs[index];
//                 TextEditingController nameController = TextEditingController();
//                 TextEditingController descriptionController =
//                     TextEditingController();
//                 TextEditingController priceController = TextEditingController();

//                 // Set initial values for the controllers
//                 nameController.text = productData['name'];
//                 descriptionController.text = productData['description'];
//                 priceController.text = productData['price'].toString();

//                 return Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                           child: Center(child: Text(productData['id']))),
//                       title: Text(productData['name']),
//                       subtitle: Text(productData['description']),
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (_) {
//                             return AlertDialog(
//                               title: Text('Update Product'),
//                               content: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   // TextFormFields for updating product information
//                                   TextFormField(
//                                     controller: nameController,
//                                     decoration: InputDecoration(
//                                       hintText: "Product Name",
//                                     ),
//                                   ),
//                                   TextFormField(
//                                     controller: descriptionController,
//                                     decoration: InputDecoration(
//                                       hintText: "Description",
//                                     ),
//                                   ),
//                                   TextFormField(
//                                     controller: priceController,
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                       hintText: "Price",
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               actions: [
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: Text("Cancel"),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     // Update the product information in Firestore
//                                     await FirebaseFirestore.instance
//                                         .collection('products')
//                                         .doc(productData.id)
//                                         .update({
//                                           'name': nameController.text,
//                                           'description':
//                                               descriptionController.text,
//                                           'price': double.parse(
//                                               priceController.text),
//                                         })
//                                         .whenComplete(
//                                             () => Navigator.pop(context))
//                                         .then((value) => Fluttertoast.showToast(
//                                             msg:
//                                                 'Updated ${nameController.text}'));
//                                   },
//                                   child: Text("Update"),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Center(child: AppUtils.customProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
