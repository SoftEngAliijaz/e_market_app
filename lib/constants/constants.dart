import 'package:flutter/material.dart';

class AppUtils {
  ///bold text method
  static TextStyle textBold() => const TextStyle(fontWeight: FontWeight.bold);

  ///splash screen bg img
  static const String splashScreenBgImg =
      'https://images.unsplash.com/photo-1702187600537-5eea13f96937?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';

  ///no dp image
  static const String noProfileImage =
      'https://dpemoji.com/wp-content/uploads/2023/10/19-1-2-500x500.jpg';

  ///CircularProgressIndicator
  static Center customProgressIndicator() => const Center(
          child: CircularProgressIndicator(
        color: Colors.red,
        backgroundColor: Colors.deepPurple,
      ));

  ///animation styles
  static TextStyle animationStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 15.0,
    );
  }

  ///profile screen info cards
  ///where we show profile info
  ///like name,email etc
  static Card userProfileCard(
    IconData leadingIcon,
    String title,
  ) {
    return Card(
        child: ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
    ));
  }

  ///app logo
  static Widget buildLogo(double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage('assets/images/e_commerce_logo.png'),
    );
  }
}

///sizedbox custom
///not added in class to access quickly
SizedBox sizedbox() => const SizedBox(height: 10);
