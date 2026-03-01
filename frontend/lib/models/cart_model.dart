import '../models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get subtotal => product.price * quantity;
}

class Cart {
  final List<CartItem> items;

  Cart({List<CartItem>? items}) : items = items ?? [];

  double get totalProductPrice =>
      items.fold(0.0, (sum, item) => sum + item.subtotal);

  double get totalDistance {
    double maxDistance = 0;

    for (final item in items) {
      print('DEBUG DISTANCE: Product=${item.product.name}, distance=${item.product.distance}, qty=${item.quantity}');
      if (item.product.distance > maxDistance) {
        maxDistance = item.product.distance;
      }
    }

    print('DEBUG: Final maxDistance=$maxDistance, deliveryCost=${maxDistance * 10}');
    return maxDistance;
  }

  double get deliveryCost => totalDistance * 10;

  double get grandTotal =>
      totalProductPrice + deliveryCost;

  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  void addItem(Product product) {
    final index = items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index != -1) {
      items[index].quantity++;
    } else {
      items.add(CartItem(product: product));
    }
  }

  void removeItem(String productId) {
    items.removeWhere(
      (item) => item.product.id == productId,
    );
  }

  void updateQuantity(String productId, int quantity) {
    final index = items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) return;

    if (quantity <= 0) {
      items.removeAt(index);
    } else {
      items[index].quantity = quantity;
    }
  }

  void clear() {
    items.clear();
  }
}