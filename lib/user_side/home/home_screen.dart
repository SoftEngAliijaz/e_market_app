import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/admin/crud_screens/product_screens/product_cart_screen.dart';
import 'package:e_market_app/admin/crud_screens/product_screens/product_fav_screen.dart';
import 'package:e_market_app/components/carousel_slider_component.dart';
import 'package:e_market_app/components/drawer_component.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Market', style: AppUtils.textBold()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Center(child: Icon(FontAwesomeIcons.search, size: 20)),
          ),
          IconButton(
            onPressed: () {
              navigateTo(context, const ProductFavScreen());
            },
            icon: const Center(child: Icon(FontAwesomeIcons.heart, size: 20)),
          ),
          IconButton(
            onPressed: () {
              navigateTo(context, ProductCartScreen());
            },
            icon: const Center(
                child: Icon(FontAwesomeIcons.cartShopping, size: 20)),
          ),
        ],
      ),
      drawer: drawerComponent(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(),
            // Stream Builder
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  debugPrint("Snapshot Error: ${snapshot.error}");
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data != null) {
                  var user = snapshot.data!;

                  // Use null-aware operators to safely access properties
                  final photoURL = user['photoUrl']?.toString() ??
                      AppUtils.splashScreenBgImg;
                  final displayName = user['displayName']?.toString() ?? '';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(photoURL),
                    ),
                    title: SelectableText("Welcome $displayName"),
                  );
                } else {
                  return const Center(child: Text('No user data found.'));
                }
              },
            ),
            const Divider(),
            // Carousel Slider
            carouselSliderMethod(),
          ],
        ),
      ),
    );
  }
}
