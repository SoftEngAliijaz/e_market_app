import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/credientals/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashBoardDrawer extends StatelessWidget {
  const AdminDashBoardDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          child: Container(),
        ),
        ListTile(
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            navigateTo(context, LogInScreen());
          },
          title: Text('Logout'),
        ),
      ],
    ));
  }
}
