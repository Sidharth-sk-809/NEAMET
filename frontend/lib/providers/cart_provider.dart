import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  Cart _cart = Cart();

  Cart get cart => _cart;
  int get itemCount => _cart.itemCount;
  double get totalProductPrice => _cart.totalProductPrice;
  double get totalDistance => _cart.totalDistance;
  double get deliveryCost => _cart.deliveryCost;
  double get grandTotal => _cart.grandTotal;
  bool get isEmpty => _cart.items.isEmpty;

  void addToCart(Product product) {
    _cart.addItem(product);
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeItem(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    _cart.updateQuantity(productId, quantity);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> getOrderItems() {
    return _cart.items.map((item) {
      return {
        'product_id': item.product.id,
        'product_name': item.product.name,
        'shop_name': item.product.shopName,
        'price': item.product.price,
        'quantity': item.quantity,
      };
    }).toList();
  }
}
