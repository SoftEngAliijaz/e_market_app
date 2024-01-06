import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/components/user_home_drawer.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:e_market_app/user_side/product_screens/product_cart_screen.dart';
import 'package:e_market_app/user_side/product_screens/product_detail_screens.dart';
import 'package:e_market_app/user_side/product_screens/product_fav_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///list for products
  List<ProductModel> allProducts = [];
  List<ProductModel> latestProducts = [];
  List<ProductModel> popularProducts = [];

  ///getting data (funtsion)
  _fetchData() async {
    await FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot? snapshot) {
      snapshot!.docs.forEach((e) {
        if (e.exists) {
          setState(() {
            ProductModel product = ProductModel(
              brand: e['brand'],
              category: e['category'],
              id: e['id'],
              productName: e['productName'],
              productDescription: e['productDescription'],
              price: e['price'],
              discountPrice: e['discountPrice'],
              serialCode: e['serialCode'],
              imageUrls: e['imageUrls'],
              isSale: e['isSale'],
              isPopular: e['isPopular'],
              isInCart: e['isInCart'],
              isInFavorite: e['isInFavorite'],
              createdAt: e['createdAt'],
            );

            allProducts.add(product);

            // Categorize products based on availability of 'createdAt' field
            if (e['createdAt'] != null) {
              DateTime createdAt = DateTime.parse(e["createdAt"]);
              DateTime lastWeek = DateTime.now().subtract(Duration(days: 7));

              if (createdAt.isAfter(lastWeek)) {
                latestProducts.add(product);
              }
            } else {
              // If 'createdAt' field doesn't exist, use an alternative method
              // to categorize products, for example, based on popularity.
              if (product.isPopular == true) {
                popularProducts.add(product);
              }
            }
          });
        }
      });
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Center(child: Icon(Icons.search, size: 20)),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const ProductFavScreen();
              }));
            },
            icon: const Center(child: Icon(Icons.favorite, size: 20)),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const ProductCartScreen();
              }));
            },
            icon: const Center(child: Icon(Icons.shopping_cart, size: 20)),
          ),
        ],
      ),
      drawer: userHomeDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display latest products
            productList("Latest Products", latestProducts),

            // Display popular products
            productList("Popular Products", popularProducts),
          ],
        ),
      ),
    );
  }

  // Widget to display product list
  Widget productList(String title, List<ProductModel> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Add a section title
        ListTile(
          leading: Icon(FontAwesomeIcons.productHunt),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ),

        // Add a horizontal scrollable list of products
        Container(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: products
                  .map((product) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
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
                                    child: Image.network(
                                      product.imageUrls != null &&
                                              product.imageUrls!.isNotEmpty
                                          ? product.imageUrls![0]
                                          : 'placeholder_url', // Replace with a placeholder image URL
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                ),
                                Expanded(child: Text(product.productName!)),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
