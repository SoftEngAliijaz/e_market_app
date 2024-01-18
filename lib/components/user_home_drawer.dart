import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/user_side/product_screens/product_cart_screen.dart';
import 'package:e_market_app/user_side/product_screens/product_fav_screen.dart';
import 'package:e_market_app/credientals/login_screen.dart';
import 'package:e_market_app/user_side/user_profile_screens/user_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///firebase auth instance
// Create a drawer component for navigation
Drawer userHomeDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        // Drawer header with the Shopbiz logo and welcome message
        DrawerHeader(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppUtils.buildLogo(50),
                SizedBox(width: 10),
                Center(
                  child: Text('WELCOME TO SHOPBIZ',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),

        // Navigate to the ProfileScreen
        _listTileComponent(context, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return const ProfileScreen();
          }));
        }, Icons.person_outline, 'Profile'),

        // Navigate to the ProductCartScreen
        _listTileComponent(context, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ProductCartScreen();
          }));
        }, Icons.shopping_bag_outlined, 'Cart'),

        // Navigate to the Product Favourite Screen
        _listTileComponent(context, () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return const ProductFavScreen();
          }));
        }, Icons.favorite_outline, 'Favorite'),

        // Sign out user and navigate to the LogInScreen
        _listTileComponent(context, () async {
          await FirebaseAuth.instance.signOut();
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) {
            return const LogInScreen();
          }), (route) => false);
        }, Icons.logout, 'LogOut'),
      ],
    ),
  );
}

// Create a common list tile component used in the drawer
Widget _listTileComponent(
  BuildContext context,
  void Function()? onTap,
  IconData leadingIcon,
  String title,
) {
  return Column(
    children: [
      ListTile(
        onTap: onTap,
        leading: Icon(leadingIcon),
        title: Text(title),
        trailing: const Icon(Icons.forward_outlined),
      ),
      const Divider(),
    ],
  );
}
