import 'package:e_market_app/user_side/product_screens/product_cart_screen.dart';
import 'package:e_market_app/user_side/product_screens/product_fav_screen.dart';
import 'package:e_market_app/components/carousel_slider_component.dart';
import 'package:e_market_app/components/user_home_drawer.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/user_side/home/user_profile_data.dart';
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
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const ProductFavScreen();
              }));
            },
            icon: const Center(child: Icon(FontAwesomeIcons.heart, size: 20)),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ProductCartScreen();
              }));
            },
            icon: const Center(
                child: Icon(FontAwesomeIcons.cartShopping, size: 20)),
          ),
        ],
      ),
      drawer: userHomeDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// user profiel data
            const UserProfileData(),

            ///Divider
            const Divider(),

            /// Carousel Slider
            carouselSliderMethod(),
          ],
        ),
      ),
    );
  }
}
