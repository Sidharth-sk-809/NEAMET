import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get subtotal => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}

class ShopGroup {
  final String shopName;
  final String shopCategory;
  final List<CartItem> items;

  ShopGroup({
    required this.shopName,
    required this.shopCategory,
    required this.items,
  });

  double get totalPrice => items.fold(0, (sum, item) => sum + item.subtotal);
  
  double get totalDistance {
    if (items.isEmpty) return 0;
    return items.first.product.distance;
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class Cart {
  final List<CartItem> items;

  Cart({List<CartItem>? items}) : items = items ?? [];

  List<ShopGroup> get groupedByShop {
    Map<String, ShopGroup> groups = {};

    for (var item in items) {
      final key = item.product.shopName;
      if (!groups.containsKey(key)) {
        groups[key] = ShopGroup(
          shopName: item.product.shopName,
          shopCategory: item.product.shopCategory,
          items: [],
        );
      }
      groups[key]!.items.add(item);
    }

    return groups.values.toList();
  }

  double get totalProductPrice => items.fold(0, (sum, item) => sum + item.subtotal);

  double get totalDistance {
    if (items.isEmpty) return 0;
    Set<String> shops = {};
    for (var item in items) {
      shops.add(item.product.shopName);
    }
    return items.first.product.distance * shops.length;
  }

  double get deliveryCost => totalDistance * 10;

  double get grandTotal => totalProductPrice + deliveryCost;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  void addItem(Product product) {
    try {
      final existingItemIndex =
          items.indexWhere((item) => item.product.id == product.id);
      if (existingItemIndex != -1) {
        items[existingItemIndex].quantity++;
      } else {
        items.add(CartItem(product: product, quantity: 1));
      }
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  void removeItem(String productId) {
    items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(String productId, int quantity) {
    final itemIndex = items.indexWhere((item) => item.product.id == productId);
    if (itemIndex != -1) {
      if (quantity <= 0) {
        items.removeAt(itemIndex);
      } else {
        items[itemIndex].quantity = quantity;
      }
    }
  }

  void clear() {
    items.clear();
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    return Cart(
      items: itemsList.map((item) => CartItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
