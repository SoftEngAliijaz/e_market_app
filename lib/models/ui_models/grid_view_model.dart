import 'dart:core';

import 'package:e_market_app/admin/admin_profile_screens/view_all_admin_screens.dart';
import 'package:e_market_app/admin/crud_screens/crud/add_product_screen.dart';
import 'package:e_market_app/admin/crud_screens/crud/delete_product_screen.dart';
import 'package:e_market_app/admin/crud_screens/crud/update_product_screen.dart';
import 'package:e_market_app/admin/crud_screens/crud/view_product_screen.dart';
import 'package:flutter/material.dart';

class GridViewModel {
  ///var
  final String? title;

  ///const
  GridViewModel({
    this.title,
  });
}

///gid model
final List<GridViewModel> gridModel = [
  GridViewModel(title: addProductScreen),
  GridViewModel(title: updateProductScreen),
  GridViewModel(title: deleteProductScreen),
  GridViewModel(title: viewProductScreen),
  GridViewModel(title: viewAllAdminsScreen),
];

///class grid model title
const String addProductScreen = 'Add Screen';
const String updateProductScreen = 'Update Screen';
const String deleteProductScreen = 'Delete Screen';
const String viewProductScreen = 'View Screen';
const String viewAllAdminsScreen = 'View All Admins';

class GridViewModelColors {
// list of colors
  static List<Color> gridViewModelCardColors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.pink,
  ];
}

class GridViewRoutes {
// navigating through out
  static navigateToScreen(BuildContext context, String screenTitle) {
    switch (screenTitle) {
      case 'Add Screen':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddProductScreen()));
        break;
      case 'Update Screen':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UpdateProductScreen()));
        break;
      case 'Delete Screen':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DeleteProductScreen()));
        break;
      case 'View All Admins':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ViewAllAdminScreen()));
        break;
      default:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ViewProductScreen()));
        break;
    }
  }
}
