import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/components/user_home_drawer.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:e_market_app/user_side/product_screens/product_cart_screen.dart';
import 'package:e_market_app/user_side/product_screens/product_detail_screens.dart';
import 'package:e_market_app/user_side/product_screens/product_fav_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> allProducts = [];

  _fetchData() async {
    try {
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
            });
          }
        });
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

  final streamData =
      FirebaseFirestore.instance.collection('products').snapshots();

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
            child: StreamBuilder<QuerySnapshot>(
              stream: streamData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: AppUtils.customProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot productValue =
                            snapshot.data!.docs[index];
                        return _buildProductCard(productValue);
                      },
                    );
                  } else {
                    return Center(child: AppUtils.customProgressIndicator());
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(DocumentSnapshot productData) {
    ProductModel productModel = ProductModel(
      brand: productData['brand'],
      category: productData['category'],
      id: productData['id'],
      productName: productData['productName'],
      productDescription: productData['productDescription'],
      price: productData['price'],
      discountPrice: productData['discountPrice'],
      serialCode: productData['serialCode'],
      imageUrls: productData['imageUrls'],
      isSale: productData['isSale'],
      isPopular: productData['isPopular'],
      isInCart: productData['isInCart'],
      isInFavorite: productData['isInFavorite'],
      createdAt: productData['createdAt'],
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
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
