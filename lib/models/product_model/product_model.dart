class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isInCart; // Existing property
  bool isInFavorite; // New property

  // Constructor
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isInCart = false, // Default value
    this.isInFavorite = false, // Default value
  });

  // Factory method to create an instance from a map (e.g., from JSON)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      isInCart: json['isInCart'] ?? false, // Existing property
      isInFavorite: json['isInFavorite'] ?? false, // New property
    );
  }

  // Convert the productModel to a map (e.g., for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isInCart': isInCart, // Existing property
      'isInFavorite': isInFavorite, // New property
    };
  }

  // Override toString for better debugging
  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl, isInCart: $isInCart, isInFavorite: $isInFavorite)';
  }

  // Override == for equality comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          price == other.price &&
          imageUrl == other.imageUrl &&
          isInCart == other.isInCart &&
          isInFavorite == other.isInFavorite;

  // Override hashCode for consistency with ==
  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      price.hashCode ^
      imageUrl.hashCode ^
      isInCart.hashCode ^
      isInFavorite.hashCode;
}
