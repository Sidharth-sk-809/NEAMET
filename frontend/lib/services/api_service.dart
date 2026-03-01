import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://neamet-backend.onrender.com';

  // Authentication
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          jsonDecode(response.body)['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Products
  Future<List<Product>> searchProducts(
    String query, {
    int range = 2,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/search?q=$query&range=$range'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> products = data['products'] ?? [];
        return products.map((p) => Product.fromJson(p)).toList();
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> products = data['products'] ?? [];
        return products.map((p) => Product.fromJson(p)).toList();
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Cart
  Future<Map<String, dynamic>> getCart(String customerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart/$customerId'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch cart');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Orders
  Future<Map<String, dynamic>> createOrder(
    String customerId,
    List<Map<String, dynamic>> items,
    double totalAmount,
    double deliveryDistance,
    double deliveryCost,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/order/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customer_id': customerId,
          'items': items,
          'total_amount': totalAmount,
          'delivery_distance': deliveryDistance,
          'delivery_cost': deliveryCost,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          jsonDecode(response.body)['message'] ?? 'Failed to create order',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> getOrderStatus(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/order/status/$orderId'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data['order'] ?? data);
      } else {
        throw Exception('Failed to fetch order status');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Employee orders
  Future<List<AvailableOrder>> getAvailableOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/available'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> orders = data['orders'] ?? [];
        return orders.map((o) => AvailableOrder.fromJson(o)).toList();
      } else {
        throw Exception('Failed to fetch available orders');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> acceptOrder(
    String orderId,
    String employeeId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/accept/$orderId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'employee_id': employeeId,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          jsonDecode(response.body)['message'] ?? 'Failed to accept order',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> getActiveDelivery(String employeeId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/delivery/active/$employeeId'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data['order'] ?? data);
      } else {
        throw Exception('No active delivery');
      }
    } catch (e) {
      rethrow;
    }
  }
}
