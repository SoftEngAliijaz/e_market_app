import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/components/admin_dash_board_drawer.dart';
import 'package:e_market_app/components/carousel_slider_component.dart';
import 'package:e_market_app/models/ui_models/grid_view_model.dart';
import 'package:flutter/material.dart';

class AdminDashBoard extends StatelessWidget {
  const AdminDashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      drawer: AdminDashBoardDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admins')
            .where('userType', isEqualTo: 'admin')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: const CircularProgressIndicator(), // Loading indicator
            );
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
            return Card(
              elevation: 2.0,
              child: ListTile(
                title: Text(data['displayName'] ?? ''),
                subtitle: Text(data['email'] ?? ''),
              ),
            );
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ...adminWidgets,
              _buildCarouselDividerAndGrid(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCarouselDividerAndGrid() {
    return Column(
      children: [
        carouselSliderMethod(),
        const Divider(),
        // Grid view & Listview
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
            final colorValue = GridViewModelColors.gridViewModelCardColors[
                index % GridViewModelColors.gridViewModelCardColors.length];
            final value = gridModel[index].title?.toString() ?? '';

            return InkWell(
              onTap: () {
                GridViewRoutes.navigateToScreen(context, value);
              },
              child: Card(
                color: colorValue,
                child: Center(
                  child: Text(
                    value,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
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
