class ProductModel {
  String? category;
  String? id;
  String? productName;
  String? productDescription;
  String? brand;
  int? price;
  int? discountPrice;
  String? serialCode;
  List<dynamic>? imageUrls;
  bool? isSale;
  bool? isPopular;
  bool? isInCart;
  bool? isInFavorite;

  ProductModel({
    this.category,
    this.id,
    this.productName,
    this.productDescription,
    this.price,
    this.brand,
    this.discountPrice,
    this.serialCode,
    this.imageUrls,
    this.isSale,
    this.isPopular,
    this.isInCart,
    this.isInFavorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      category: json['category'],
      id: json['id'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      price: json['price'],
      brand: json['brand'],
      discountPrice: json['discountPrice'],
      serialCode: json['serialCode'],
      imageUrls: json['imageUrls'],
      isSale: json['isSale'],
      isPopular: json['isPopular'],
      isInCart: json['isInCart'],
      isInFavorite: json['isInFavorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'id': id,
      'productName': productName,
      'productDescription': productDescription,
      'price': price,
      'brand': brand,
      'discountPrice': discountPrice,
      'serialCode': serialCode,
      'imageUrls': imageUrls,
      'isSale': isSale,
      'isPopular': isPopular,
      'isInCart': isInCart,
      'isInFavorite': isInFavorite,
    };
  }
}
