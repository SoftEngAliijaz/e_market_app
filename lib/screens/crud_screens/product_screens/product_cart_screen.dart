import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cart').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No items in the cart'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // Retrieve cart item data from Firestore
              final cartItem =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: CircleAvatar(child: Text(cartItem['id'].toString())),
                title: Text(cartItem['name'] ?? 'Product Name'),
                subtitle: Text(cartItem['description'] ?? 'Description'),
                trailing: Text(cartItem['price'].toString()),
              );
            },
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:shopbiz_app/models/product_model/product_model.dart';

// class ProductCartScreen extends StatelessWidget {
//   final List<ProductModel> cartProducts;

//   const ProductCartScreen({Key? key, this.cartProducts}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cart'),
//       ),
//       body: cartProducts.isNotEmpty
//           ? ListView.builder(
//               itemCount: cartProducts.length,
//               itemBuilder: (context, index) {
//                 final product = cartProducts[index];
//                 return ListTile(
//                   title: Text(product.name),
//                   subtitle: Text(product.description),
//                   trailing: Text(product.price.toString()),
//                 );
//               },
//             )
//           : Center(
//               child: Text('No items in the cart'),
//             ),
//     );
//   }
// }
