class Product {
  final String id;
  final String name;
  final String shopName;
  final String shopCategory;
  final double price;
  final double distance;
  final String? imageUrl;
  final String description;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.shopName,
    required this.shopCategory,
    required this.price,
    required this.distance,
    this.imageUrl,
    required this.description,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['product_name'] ?? json['name'] ?? '',
      shopName: json['shop_name'] ?? '',
      shopCategory: json['shop_category'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'] ?? 0.0,
      distance: (json['distance'] is int)
          ? (json['distance'] as int).toDouble()
          : json['distance'] ?? 0.0,
      imageUrl: json['image_url'],
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shop_name': shopName,
      'shop_category': shopCategory,
      'price': price,
      'distance': distance,
      'image_url': imageUrl,
      'description': description,
      'quantity': quantity,
    };
  }

  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      shopName: shopName,
      shopCategory: shopCategory,
      price: price,
      distance: distance,
      imageUrl: imageUrl,
      description: description,
      quantity: quantity ?? this.quantity,
    );
  }
}
