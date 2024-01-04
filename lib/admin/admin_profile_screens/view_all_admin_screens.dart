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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AdminListView(),
      ),
    );
  }
}

class AdminListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('admins').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.hasData) {
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No admins available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final adminData = snapshot.data!.docs[index];

                return AdminCard(
                  adminName: adminData['name'] ?? 'Unknown',
                  adminEmail: adminData['email'] ?? 'Unknown',
                );
              },
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class AdminCard extends StatelessWidget {
  final String adminName;
  final String adminEmail;

  const AdminCard({
    Key? key,
    required this.adminName,
    required this.adminEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
