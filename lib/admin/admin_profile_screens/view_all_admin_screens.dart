import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAllAdminScreen extends StatelessWidget {
  const ViewAllAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View All Admins'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admins')
            .where('userType', isEqualTo: 'admin')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator
            return const Center(child: CircularProgressIndicator());
          }

          // If there is no data, display a message
          if (snapshot.data?.docs.isEmpty ?? true) {
            return const Center(
              child: Text('No admin users found'),
            );
          }

          // If there is data, build a list of cards
          final List<Widget> adminWidgets =
              snapshot.data!.docs.map((DocumentSnapshot document) {
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
