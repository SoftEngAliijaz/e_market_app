import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/db_collections.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:flutter/material.dart';

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
        title: Text(widget.product?.productName ?? 'Product Detail'),
      ),
      bottomNavigationBar: SizedBox(
        child: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  backgroundColor: (widget.product?.isInCart == true)
                      ? Colors.grey
                      : Colors.blue,
                  iconColor: Colors.red,
                ),
                onPressed: _toggleCart,
                icon: Icon(
                  (widget.product?.isInCart == true) ? Icons.check : Icons.add,
                ),
                label: Text(
                  (widget.product?.isInCart == true)
                      ? 'In Cart'
                      : 'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  backgroundColor: (widget.product?.isInFavorite == true)
                      ? Colors.red
                      : Colors.blue,
                  iconColor: Colors.white,
                ),
                onPressed: _toggleFavorite,
                icon: Icon(
                  (widget.product?.isInFavorite == true)
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                label: Text(
                  (widget.product?.isInFavorite == true)
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
                child: Row(
                  children: widget.product!.imageUrls!.map((imageUrlValues) {
                    return Image.network(
                      widget.product!.imageUrls!.length.toString(),
                    );
                  }).toList(),
                  // child: Image.network(
                  //   widget.product?.imageUrls?.first ?? '',
                  //   fit: BoxFit.contain,
                  //   width: double.infinity,
                  // ),
                ),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Text(widget.product?.id ?? 'N/A'),
              ),
              title: Text(widget.product?.productName ?? 'N/A'),
              subtitle: Text(widget.product?.productDescription ?? 'N/A'),
              trailing: Text(widget.product?.price?.toString() ?? 'N/A'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCart() async {
    if (widget.product != null) {
      // Toggle the isInCart property
      setState(() {
        widget.product!.isInCart = !(widget.product!.isInCart ?? false);
      });

      // Add or remove the product from the cart collection in Firestore
      final cartReference = FirebaseFirestore.instance
          .collection(DatabaseCollection.cartCollection);

      if (widget.product!.isInCart == true) {
        // Add to cart
        await cartReference.doc(widget.product!.id).set({
          'id': widget.product!.id,
          'productName': widget.product!.productName,
          'productDescription': widget.product!.productDescription,
          'price': widget.product!.price,
          'imageUrls': widget.product!.imageUrls,
        });
        Navigator.pop(context); // Go back to the previous screen
      } else {
        // Remove from cart
        await cartReference.doc(widget.product!.id).delete();
      }
    }
  }

  void _toggleFavorite() async {
    if (widget.product != null) {
      // Toggle the isInFavorite property
      setState(() {
        widget.product!.isInFavorite = !(widget.product!.isInFavorite ?? false);
      });

      // Add or remove the product from the favorites collection in Firestore
      final favoritesReference = FirebaseFirestore.instance
          .collection(DatabaseCollection.favoriteCollection);

      if (widget.product!.isInFavorite == true) {
        // Add to favorites
        await favoritesReference.doc(widget.product!.id).set({
          'id': widget.product!.id,
          'productName': widget.product!.productName,
          'productDescription': widget.product!.productDescription,
          'price': widget.product!.price,
          'imageUrls': widget.product!.imageUrls,
        });
        Navigator.pop(context); // Go back to the previous screen
      } else {
        // Remove from favorites
        await favoritesReference.doc(widget.product!.id).delete();
      }
    }
  }
}
