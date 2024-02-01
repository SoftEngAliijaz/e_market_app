import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/constants/db_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileData extends StatelessWidget {
  const UserProfileData({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(DatabaseCollection.usersCollection)
            .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: AppUtils.customProgressIndicator());
          } else if (snapshot.hasError) {
            debugPrint("Snapshot Error: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            var user = snapshot.data!;

            // Use null-aware operators to safely access properties
            final photoURL =
                user['photoUrl']?.toString() ?? AppUtils.noProfileImage;
            final displayName = user['displayName']?.toString() ?? '';

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(photoURL),
              ),
              title: SelectableText("Welcome: $displayName"),
            );
          } else {
            return const Center(child: Text('No user data found.'));
          }
        },
      ),
    );
  }
}
