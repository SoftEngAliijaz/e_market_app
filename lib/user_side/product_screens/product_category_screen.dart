import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:e_market_app/user_side/product_screens/product_detail_screens.dart';
import 'package:flutter/material.dart';

class ProductCategoryScreen extends StatelessWidget {
  final String category;
  final List<ProductModel> products;

  const ProductCategoryScreen({
    Key? key,
    required this.category,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildProductCard(context, products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext buildContext,
    ProductModel productModel,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          buildContext,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: productModel),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: productModel.imageUrls != null &&
                          productModel.imageUrls!.isNotEmpty
                      ? Image.network(
                          productModel.imageUrls![0],
                          height: 80,
                          width: 80,
                        )
                      : Placeholder(child: Text('PlaceHolder')),
                ),
              ),
              Expanded(child: Text(productModel.productName!)),
            ],
          ),
        ),
      ),
    );
  }
}
