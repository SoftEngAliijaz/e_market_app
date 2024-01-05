import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/components/user_home_drawer.dart';
import 'package:e_market_app/models/product_model/categories_model.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:e_market_app/user_side/product_screens/product_cart_screen.dart';
import 'package:e_market_app/user_side/product_screens/product_fav_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List images = [
    "https://cdn.pixabay.com/photo/2015/09/21/14/24/supermarket-949913_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/19/08/hangers-1850082_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/07/24/21/01/thermometer-1539191_960_720.jpg",
    "https://cdn.pixabay.com/photo/2015/09/21/14/24/supermarket-949913_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/19/08/hangers-1850082_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/07/24/21/01/thermometer-1539191_960_720.jpg",
  ];

  List<ProductModel> allProducts = [];

  getDate() async {
    await FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot? snapshot) {
      snapshot!.docs.forEach((e) {
        if (e.exists) {
          setState(() {
            allProducts.add(
              ProductModel(
                brand: e["brand"],
                category: e["category"],
                id: e['id'],
                productName: e["productName"],
                productDescription: e["detail"],
                price: e["price"],
                discountPrice: e["discountPrice"],
                serialCode: e["serialCode"],
                imageUrls: e["imageUrls"],
                isSale: e["isOnSale"],
                isPopular: e["isPopular"],
                isInCart: e['isCart'],
                isInFavorite: e["isFavourite"],
              ),
            );
          });
        }
      });
    });
    print(allProducts[0].discountPrice);
  }

  @override
  void initState() {
    getDate();
    super.initState();
  }

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// user profile data
            // TODO: Implement user profile data widget here

            /// Carousel Slider
            carouselSliderMethod(),
          ],
        ),
      ),
    );
  }

  Widget carouselSliderMethod() {
    return CarouselSlider(
      items: images
          .map((e) => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        imageUrl: e,
                        placeholder: (c, i) =>
                            Center(child: Image.asset(categories[0].image!)),
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(colors: [
                            Colors.blueAccent.withOpacity(0.3),
                            Colors.redAccent.withOpacity(0.3),
                          ])),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "TITLE",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ))
          .toList(),
      options: CarouselOptions(
        height: 140,
        autoPlay: true,
      ),
    );
  }
}
