import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';
import '../models/order_model.dart';

class ApiService {
  static const String baseUrl = 'https://neamet-backend.onrender.com';

  // ================= LOGIN =================

  Future<Map<String, dynamic>> login(String id, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }

  // ================= PRODUCTS =================

  Future<List<Product>> searchProducts(String query,
      {int range = 2}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/search?q=$query&range=$range'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> products =
          data is List ? data : data['products'] ?? [];
      return products.map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }

  Future<List<Product>> getAllProducts() async {
    final response =
        await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> products =
          data is List ? data : data['products'] ?? [];
      return products.map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  // ================= CART =================

  Future<Map<String, dynamic>> getCart(String customerId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/cart/$customerId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch cart');
    }
  }

  // ================= CREATE ORDER =================

  Future<Map<String, dynamic>> createOrder(
    String customerId,
    List<Map<String, dynamic>> items,
    double totalAmount,
    double deliveryDistance,
    double deliveryCost,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/order/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customer_id': customerId,
        'items': items,
        'total_product_cost': totalAmount,
        'total_distance': deliveryDistance,
        'delivery_cost': deliveryCost,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create order');
    }
  }

  // ================= ORDER STATUS =================

  Future<Order> getOrderStatus(String orderId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/order/status/$orderId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Order.fromJson(data['order'] ?? data);
    } else {
      throw Exception('Failed to fetch order status');
    }
  }

  // ================= EMPLOYEE =================

  Future<List<AvailableOrder>> getAvailableOrders() async {
    final response =
        await http.get(Uri.parse('$baseUrl/orders/available'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> orders =
          data is List ? data : data['orders'] ?? [];
      return orders
          .map((o) => AvailableOrder.fromJson(o))
          .toList();
    } else {
      throw Exception('Failed to fetch available orders');
    }
  }

  Future<Map<String, dynamic>> acceptOrder(
      String orderId, String employeeId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders/accept/$orderId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'employee_id': employeeId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to accept order');
    }
  }

  Future<Order> getActiveDelivery(String employeeId) async {
    final response = await http
        .get(Uri.parse('$baseUrl/delivery/active/$employeeId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Order.fromJson(data['order'] ?? data);
    } else {
      throw Exception('No active delivery');
    }
  }
}