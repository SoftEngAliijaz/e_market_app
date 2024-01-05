import 'package:e_market_app/admin/admin_profile_screens/view_all_admin_screens.dart';
import 'package:e_market_app/admin/crud_screens/crud/add_product_screen.dart';
import 'package:e_market_app/admin/crud_screens/crud/delete_product_screen.dart';
import 'package:e_market_app/admin/crud_screens/crud/update_product_screen.dart';
import 'package:e_market_app/admin/crud_screens/crud/view_product_screen.dart';
import 'package:e_market_app/admin/dashboard/admin_dashboard_screen.dart';
import 'package:e_market_app/credientals/login_screen.dart';
import 'package:flutter/material.dart';

class AdminDashBoardDrawer extends StatelessWidget {
  const AdminDashBoardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                    ),
                  ),
                  Center(
                      child: Text(
                    'Welcome Admin',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
                ],
              ),
            ),
          ),

          /// Admin dashboard tile
          _listTileComponent(context, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const AdminDashBoard();
            }));
          }, Icons.home, 'Admin Dashboard'),

          /// Add Product tile
          _listTileComponent(context, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return AddProductScreen();
            }));
          }, Icons.add, 'Add Product'),

          /// Update Product tile
          _listTileComponent(context, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const UpdateProductScreen();
            }));
          }, Icons.update, 'Update Product'),

          /// Delete Product tile
          _listTileComponent(context, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const DeleteProductScreen();
            }));
          }, Icons.delete, 'Delete Product'),

          /// View Product tile
          _listTileComponent(context, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const ViewProductScreen();
            }));
          }, Icons.view_agenda, 'View Product'),

          /// View all admins tile
          _listTileComponent(context, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return const ViewAllAdminScreen();
            }));
          }, Icons.admin_panel_settings, 'View All Admins'),

          /// Logout tile
          _listTileComponent(context, () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) {
              return const LogInScreen();
            }), (route) => false);
          }, Icons.logout, 'Logout'),
        ],
      ),
    );
  }
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
