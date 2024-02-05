import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/constants/db_collections.dart';
import 'package:e_market_app/credientals/login_screen.dart';
import 'package:e_market_app/admin/dashboard/admin_dashboard_screen.dart';
import 'package:e_market_app/user_side/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserActivityCycleScreen extends StatelessWidget {
  const UserActivityCycleScreen({Key? key}) : super(key: key);

  Future<bool> isAdminUser(String userId) async {
    bool isAdmin = false;

    try {
      // Retrieve additional user data from Firestore or another source
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection(DatabaseCollection
              .adminsCollection) // Change to 'admins' collection
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        isAdmin = true;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error checking admin status: $e');
    }

    return isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: AppUtils.customProgressIndicator()); // Loading indicator
        }

        if (snapshot.hasError) {
          // Display an error message on the UI
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // If the user is logged out, return the login screen
          return const LogInScreen();
        } else {
          return FutureBuilder<bool>(
            future: isAdminUser(user.uid),
            builder: (context, adminSnapshot) {
              if (adminSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child:
                      AppUtils.customProgressIndicator(), // Loading indicator
                );
              }

              bool isAdmin = adminSnapshot.data ?? false;

              // Return the appropriate screen based on user role
              if (isAdmin) {
                return const AdminDashBoard();
              } else {
                return const HomeScreen();
              }
            },
          );
        }
      },
    );
  }
}
