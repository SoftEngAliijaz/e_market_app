import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopbiz_app/constants/constants.dart';

class DeleteProductScreen extends StatelessWidget {
  const DeleteProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Products'),
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
                      child: Center(child: Text(productData['id'])),
                    ),
                    title: Text(productData['name']),
                    subtitle: Text(productData['description']),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
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
                                    await FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(productData.id)
                                        .delete()
                                        .whenComplete(
                                            () => Navigator.pop(context))
                                        .then((value) => Fluttertoast.showToast(
                                            msg:
                                                'Deleted ${productData['name']}'));
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


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shopbiz_app/constants/constants.dart';

// class DeleteProductScreen extends StatelessWidget {
//   const DeleteProductScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Delete Products'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('products').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // Display a loading indicator while waiting for data
//             return Center(child: AppUtils.customProgressIndicator());
//           }

//           if (!snapshot.hasData ||
//               snapshot.data == null ||
//               snapshot.data!.docs.isEmpty) {
//             // Display a message if there is no data
//             return const Center(
//                 child: Text('No products available to Delete.'));
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               final productData = snapshot.data!.docs[index];

//               return Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                         child: Center(child: Text(productData['id']))),
//                     title: Text(productData['name']),
//                     subtitle: Text(productData['description']),
//                     trailing: IconButton(
//                       onPressed: () {
//                         // Show a confirmation dialog when delete button is pressed
//                         showDialog(
//                           context: context,
//                           builder: (_) {
//                             return AlertDialog(
//                               title: Text('Are You Sure?'),
//                               content:
//                                   Text('Do you want to delete this product?'),
//                               actions: [
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     // Cancel deletion
//                                     Navigator.pop(context);
//                                   },
//                                   child: Text("No"),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     // Delete the product from Firestore
//                                     await FirebaseFirestore.instance
//                                         .collection('products')
//                                         .doc(productData.id)
//                                         .delete()
//                                         .whenComplete(
//                                             () => Navigator.pop(context))
//                                         .then((value) => Fluttertoast.showToast(
//                                             msg:
//                                                 'Deleted ${productData['name']}'));
//                                   },
//                                   child: const Text("Yes"),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       },
//                       icon: const Icon(
//                         Icons.delete,
//                         color: Colors.red,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
