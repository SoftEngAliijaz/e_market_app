class CategoriesModel {
  String? title;
  String? image;

  CategoriesModel({
    required this.title,
    this.image,
  });
}

List<CategoriesModel> categories = [
  CategoriesModel(title: "GROCERY"),
  CategoriesModel(title: "ELECTRONICES"),
  CategoriesModel(title: "COSMETICS"),
  CategoriesModel(title: "PHARMACY"),
  CategoriesModel(title: "GARMENTS")
];
/*
  image: 'assets/c_images/grocery.png'
    image: 'assets/c_images/electronics.png'
      image: 'assets/c_images/cosmatics.png'
        image: 'assets/c_images/pharmacy.png'
          simage: 'assets/c_images/garments.png')
*/