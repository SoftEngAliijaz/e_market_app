class CategoriesModel {
  String? title;
  String? image;

  CategoriesModel({required this.title, this.image});
}

List<CategoriesModel> categories = [
  CategoriesModel(title: "GROCERY", image: 'assets/c_images/grocery.png'),
  CategoriesModel(
      title: "ELECTRONICES", image: 'assets/c_images/electronics.png'),
  CategoriesModel(title: "COSMETICS", image: 'assets/c_images/cosmatics.png'),
  CategoriesModel(title: "PHARMACY", image: 'assets/c_images/pharmacy.png'),
  CategoriesModel(title: "GARMENTS", image: 'assets/c_images/garments.png'),
];
