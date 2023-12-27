import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopbiz_app/constants/constants.dart';
import 'package:shopbiz_app/models/product_model/product_model.dart';
import 'package:shopbiz_app/screens/crud_screens/product_screens/product_cart_screen.dart';
import 'package:shopbiz_app/screens/crud_screens/product_screens/product_fav_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product?.name ?? 'Product Detail'),
      ),
      bottomNavigationBar: SizedBox(
        child: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  backgroundColor:
                      widget.product!.isInCart ? Colors.grey : Colors.blue,
                  iconColor: Colors.red,
                ),
                onPressed: _toggleCart,
                icon: Icon(
                  widget.product!.isInCart ? Icons.check : Icons.add,
                ),
                label: Text(
                  widget.product!.isInCart ? 'In Cart' : 'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  backgroundColor:
                      widget.product!.isInFavorite ? Colors.red : Colors.blue,
                  iconColor: Colors.white,
                ),
                onPressed: _toggleFavorite,
                icon: Icon(
                  widget.product!.isInFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                label: Text(
                  widget.product!.isInFavorite
                      ? 'In Favorites'
                      : 'Add to Favorites',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Center(
                child: Image.network(
                  widget.product?.imageUrl ?? '',
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Text(widget.product?.id ?? 'N/A'),
              ),
              title: Text(widget.product?.name ?? 'N/A'),
              subtitle: Text(widget.product?.description ?? 'N/A'),
              trailing: Text(widget.product?.price.toString() ?? 'N/A'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCart() async {
    // Toggle the isInCart property
    setState(() {
      widget.product!.isInCart = !widget.product!.isInCart;
    });

    // Add or remove the product from the cart collection in Firestore
    final cartReference = FirebaseFirestore.instance.collection('cart');

    if (widget.product!.isInCart) {
      // Add to cart
      await cartReference.doc(widget.product!.id).set({
        'id': widget.product!.id,
        'name': widget.product!.name,
        'description': widget.product!.description,
        'price': widget.product!.price,
        'image': widget.product!.imageUrl,
      });
      navigateTo(context, ProductCartScreen());
    } else {
      // Remove from cart
      await cartReference.doc(widget.product!.id).delete();
    }
  }

  void _toggleFavorite() async {
    // Toggle the isInFavorite property
    setState(() {
      widget.product!.isInFavorite = !widget.product!.isInFavorite;
    });

    // Add or remove the product from the favorites collection in Firestore
    final favoritesReference =
        FirebaseFirestore.instance.collection('favorites');

    if (widget.product!.isInFavorite) {
      // Add to favorites
      await favoritesReference.doc(widget.product!.id).set({
        'id': widget.product!.id,
        'name': widget.product!.name,
        'description': widget.product!.description,
        'price': widget.product!.price,
        'image': widget.product!.imageUrl,
      });
      navigateTo(context, ProductFavScreen());
    } else {
      // Remove from favorites
      await favoritesReference.doc(widget.product!.id).delete();
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:shopbiz_app/models/product_model/product_model.dart';

// class ProductDetailScreen extends StatefulWidget {
//   final String? getId;
//   final String? getTitle;
//   final String? getDescription;
//   final String? getPrice;
//   final String? getImage;
//   final ProductModel? product;

//   const ProductDetailScreen({
//     Key? key,
//     this.getId,
//     this.getTitle,
//     this.getDescription,
//     this.getPrice,
//     this.getImage,
//     this.product,
//   }) : super(key: key);

//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.getTitle!),
//       ),
//       bottomNavigationBar: SizedBox(
//         child: Row(
//           children: [
//             Expanded(
//               child: TextButton.icon(
//                 style: TextButton.styleFrom(
//                   shape:
//                       RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//                   backgroundColor: Colors.blue,
//                   iconColor: Colors.red,
//                 ),
//                 onPressed: () {},
//                 icon: Icon(Icons.favorite),
//                 label: Text(
//                   'Add to Favitore',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: TextButton.icon(
//                 style: TextButton.styleFrom(
//                   shape:
//                       RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//                   backgroundColor: Colors.blue,
//                   iconColor: Colors.red,
//                 ),
//                 onPressed: () {},
//                 icon: Icon(Icons.shopping_bag),
//                 label: Text(
//                   'Add to Cart',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             Container(
//               height: 300,
//               width: double.infinity,
//               child: Center(
//                 child: Image.network(
//                   widget.getImage!,
//                   fit: BoxFit.contain,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: CircleAvatar(
//                 child: Text(widget.getId!),
//               ),
//               title: Text(widget.getTitle!),
//               subtitle: Text(widget.getDescription!),
//               trailing: Text(widget.getPrice!),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
