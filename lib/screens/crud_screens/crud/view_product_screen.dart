import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopbiz_app/constants/constants.dart';
import 'package:shopbiz_app/models/product_model/product_model.dart';
import 'package:shopbiz_app/screens/crud_screens/product_screens/product_detail_screens.dart';

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

                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ProductDetailScreen(
                          product: ProductModel.fromJson(
                              productData.data() as Map<String, dynamic>),
                        );
                      }));
                    },
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
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
            Divider(),
            ListTile(
              tileColor: Colors.white,
              leading: CircleAvatar(
                child: Center(
                  child: Text(
                    product.id,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              title: Text(product.name),
              subtitle: Text(product.description),
              trailing: Text("Price: ${product.price}"),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shopbiz_app/constants/constants.dart';
// import 'package:shopbiz_app/screens/crud_screens/product_screens/product_detail_screens.dart';

// class ViewProductScreen extends StatelessWidget {
//   const ViewProductScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('View Products'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('products').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           // 1. Check if connection state is active or has data
//           if (snapshot.connectionState == ConnectionState.active ||
//               snapshot.hasData) {
//             // 2. Check if snapshot data is null or the document list is empty
//             if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
//               // 3. Display a loading indicator if there is no data yet
//               return Center(child: Text('No products available'));
//             } else {
//               // 4. Display the list of products
//               return ListView.separated(
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   // 5. Access individual product data
//                   final productData = snapshot.data!.docs[index];

//                   return InkWell(
//                     onTap: () {
//                       // 6. Navigate to the product detail screen when tapped
//                       Navigator.push(context, MaterialPageRoute(builder: (_) {
//                         return ProductDetailScreen(
//                           getId: productData['id'],
//                           getTitle: productData['name'],
//                           getDescription: productData['description'],
//                           getPrice: productData['price'],
//                           getImage: productData['imageUrl'],
//                         );
//                       }));
//                     },
//                     child: _productCard(productData),
//                   );
//                 },
//                 separatorBuilder: (context, index) {
//                   // 7. Divider between product items
//                   return const Divider();
//                 },
//               );
//             }
//           } else {
//             // 8. Display a loading indicator if the connection state is not active
//             return Center(child: AppUtils.customProgressIndicator());
//           }
//         },
//       ),
//     );
//   }

//   Card _productCard(QueryDocumentSnapshot<Object?> productData) {
//     return Card(
//       color: Colors.white,
//       child: Container(
//         height: 300,
//         width: 300,
//         child: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 color: Colors.white,
//                 child: Image.network(
//                   // 9. Load product image from the network
//                   productData['imageUrl'],
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             Divider(),
//             ListTile(
//               tileColor: Colors.white,
//               leading: CircleAvatar(
//                 child: Center(
//                   // 10. Display product ID in the circle avatar
//                   child: Text(
//                     productData['id'],
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//               // 11. Display product name in the title
//               title: Text(productData['name']),
//               // 12. Display product description in the subtitle
//               subtitle: Text(productData['description']),
//               trailing: Text("Price: ${productData['price']}"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
