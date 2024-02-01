import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/components/user_home_drawer.dart';
import 'package:e_market_app/constants/db_collections.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:e_market_app/user_side/product_screens/product_cart_screen.dart';
import 'package:e_market_app/user_side/product_screens/product_category_screen.dart';
import 'package:e_market_app/user_side/product_screens/product_fav_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///
  List<String> uniqueCategories = [];
  List<ProductModel> allProducts = [];

  ///fetching data
  _fetchData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("products").get();

      // Clear the previous data
      uniqueCategories.clear();
      allProducts.clear();

      snapshot.docs.forEach((DocumentSnapshot e) {
        if (e.exists) {
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

          // Add category to the list if it's not already present
          if (!uniqueCategories.contains(product.category)) {
            uniqueCategories.add(product.category!);
          }
        }
      });
    } catch (e) {
      print("Error fetching data: $e");
      Fluttertoast.showToast(msg: "Error fetching data: $e");
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  final streamData = FirebaseFirestore.instance
      .collection(DatabaseCollection.productCollection)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Market'),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: uniqueCategories.length,
              itemBuilder: (BuildContext context, int index) {
                String category = uniqueCategories[index];
                return ListTile(
                  title: Text(category),
                  onTap: () {
                    // Navigate to a screen showing products for the selected category
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductCategoryScreen(
                          category: category,
                          products: allProducts
                              .where((product) => product.category == category)
                              .toList(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
