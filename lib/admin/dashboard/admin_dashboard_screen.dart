import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/components/drawers/admin_dash_board_drawer.dart';
import 'package:e_market_app/components/slider/carousel_slider_component.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/constants/db_collections.dart';
import 'package:e_market_app/models/ui_models/grid_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashBoard extends StatelessWidget {
  const AdminDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: const AdminDashBoardDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(DatabaseCollection.adminsCollection)
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('userType', isEqualTo: 'admin')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: AppUtils.customProgressIndicator());
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
              title: Text("Welcome: ${data['displayName'] ?? 'N/A'}"),
              subtitle: Text("Email: ${data['email'] ?? 'N/A'}"),
            );
          }).toList();

          return ListView(
            children: [
              ...adminWidgets,
              sizedbox(),
              carouselSliderMethod(),
              _buildGridViewItems(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGridViewItems() {
    return Column(
      children: [
        /// Grid view & Listview
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: gridModel.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemBuilder: (BuildContext context, int index) {
            ///color values
            final colorValue = GridViewModelColors.gridViewModelCardColors[
                index % GridViewModelColors.gridViewModelCardColors.length];

            ///grid values
            final textValue = gridModel[index].title?.toString() ?? '';

            return InkWell(
              onTap: () {
                GridViewRoutes.navigateToScreen(context, textValue);
              },
              child: Card(
                color: colorValue,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          textValue,
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
