import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopbiz_app/components/carousel_slider_component.dart';
import 'package:shopbiz_app/components/drawer_component.dart';
import 'package:shopbiz_app/constants/constants.dart';
import 'package:shopbiz_app/models/ui_models/grid_view_model.dart';
import 'package:shopbiz_app/screens/crud_screens/product_screens/product_cart_screen.dart';
import 'package:shopbiz_app/screens/crud_screens/product_screens/product_fav_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopbiz', style: AppUtils.textBold()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Center(child: const Icon(FontAwesomeIcons.search, size: 20)),
          ),
          IconButton(
            onPressed: () {
              navigateTo(context, ProductFavScreen());
            },
            icon: Center(child: const Icon(FontAwesomeIcons.heart, size: 20)),
          ),
          IconButton(
            onPressed: () {
              navigateTo(context, ProductCartScreen());
            },
            icon: Center(
                child: const Icon(FontAwesomeIcons.cartShopping, size: 20)),
          ),
        ],
      ),
      drawer: Components.drawerComponent(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Divider(),
            // Stream Builder
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  debugPrint("Snapshot Error: ${snapshot.error}");
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data != null) {
                  var user = snapshot.data!;

                  // Use null-aware operators to safely access properties
                  final photoURL = user['photoURL']?.toString() ??
                      AppUtils.splashScreenBgImg;
                  final displayName = user['displayName']?.toString() ?? '';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(photoURL),
                    ),

                    ///Creates a selectable text widget.
                    title: SelectableText("Welcome $displayName"),
                  );
                } else {
                  return Center(child: Text('No user data found.'));
                }
              },
            ),
            Divider(),
            // Carousel Slider
            carouselSliderMethod(),
            Divider(),
            // Grid view & Listview
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: gridModel.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemBuilder: (BuildContext context, int index) {
                final colorValue = GridViewModelColors.gridViewModelCardColors[
                    index % GridViewModelColors.gridViewModelCardColors.length];
                final value = gridModel[index].title?.toString() ?? '';

                return InkWell(
                  onTap: () {
                    GridViewRoutes.navigateToScreen(context, value);
                  },
                  child: Card(
                    color: colorValue,
                    child: Center(
                      child: Text(
                        value,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
