import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:e_market_app/constants/constants.dart' as k;
import 'package:e_market_app/constants/db_collections.dart' as collections;
import 'package:flutter/material.dart';

class ViewAllAdminScreen extends StatelessWidget {
  const ViewAllAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View All Admins'),
      ),
      body: StreamBuilder<cloud_firestore.QuerySnapshot>(
        stream: cloud_firestore.FirebaseFirestore.instance
            .collection(collections.DatabaseCollection.adminsCollection)
            .where('userType', isEqualTo: 'admin')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<cloud_firestore.QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator
            return Center(child: k.AppUtils.customProgressIndicator());
          }

          // If there is no data, display a message
          if (snapshot.data?.docs.isEmpty ?? true) {
            return const Center(
              child: Text('No admin users found'),
            );
          }

          // If there is data, build a list of cards
          final List<Widget> adminWidgets = snapshot.data!.docs
              .map((cloud_firestore.DocumentSnapshot document) {
            // Access the data in each document
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            // Customize this part based on your data structure
            return ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: Text("Welcome: ${data['displayName'] ?? ''}"),
              subtitle: Text("Email: ${data['email'] ?? ''}"),
            );
          }).toList();

          return ListView(
            children: [
              ...adminWidgets,
            ],
          );
        },
      ),
    );
  }

  Widget profileCard(String adminName, String adminEmail) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.admin_panel_settings),
        title: Text(adminName),
        subtitle: Text(adminEmail),
      ),
    );
  }
}
