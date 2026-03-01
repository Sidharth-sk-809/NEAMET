import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';
import '../models/order_model.dart';

class ApiService {
  static const String baseUrl = 'https://neamet-backend.onrender.com';

  // ==============================
  // AUTHENTICATION
  // ==============================

  Future<Map<String, dynamic>> login(String id, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'id': id,
              'password': password,
            }),
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () =>
                throw Exception('Server timeout (Render may be waking up)'),
          );

      print("LOGIN STATUS: ${response.statusCode}");
      print("LOGIN RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      throw Exception('Login Error: $e');
    }
  }

  // ==============================
  // PRODUCTS
  // ==============================

  Future<List<Product>> searchProducts(String query,
      {int range = 2}) async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '$baseUrl/products/search?q=$query&range=$range'),
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () =>
                throw Exception('Server timeout (Render may be waking up)'),
          );

      print("SEARCH STATUS: ${response.statusCode}");
      print("SEARCH RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Adjust depending on backend response format
        final List<dynamic> products = data is List
            ? data
            : data['products'] ?? [];

        return products.map((p) => Product.fromJson(p)).toList();
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      throw Exception('Search Error: $e');
    }
  }

  // ==============================
  // CART
  // ==============================

  Future<Map<String, dynamic>> getCart(String customerId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/cart/$customerId'))
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () =>
                throw Exception('Server timeout (Render may be waking up)'),
          );

      print("CART STATUS: ${response.statusCode}");
      print("CART RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch cart');
      }
    } catch (e) {
      throw Exception('Cart Error: $e');
    }
  }

  // ==============================
  // CREATE ORDER
  // ==============================

  Future<Map<String, dynamic>> createOrder({
    required String customerId,
    required List<Map<String, dynamic>> items,
    required double totalProductCost,
    required double totalDistance,
    required double deliveryCost,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/order/create'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'customer_id': customerId,
              'items': items,
              'total_product_cost': totalProductCost,
              'total_distance': totalDistance,
              'delivery_cost': deliveryCost,
            }),
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () =>
                throw Exception('Server timeout (Render may be waking up)'),
          );

      print("CREATE ORDER STATUS: ${response.statusCode}");
      print("CREATE ORDER RESPONSE: ${response.body}");

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Create Order Error: $e');
    }
  }

  // ==============================
  // ORDER STATUS (CUSTOMER)
  // ==============================

  Future<Order> getOrderStatus(String orderId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/order/status/$orderId'))
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () =>
                throw Exception('Server timeout (Render may be waking up)'),
          );

      print("ORDER STATUS: ${response.statusCode}");
      print("ORDER RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Order.fromJson(data['order'] ?? data);
      } else {
        throw Exception('Failed to fetch order status');
      }
    } catch (e) {
      throw Exception('Order Status Error: $e');
    }
  }

  // ==============================
  // EMPLOYEE - AVAILABLE ORDERS
  // ==============================

  Future<List<AvailableOrder>> getAvailableOrders() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/orders/available'))
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () =>
                throw Exception('Server timeout (Render may be waking up)'),
          );

      print("AVAILABLE ORDERS STATUS: ${response.statusCode}");
      print("AVAILABLE ORDERS RESPONSE: ${response.body}");

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
    } catch (e) {
      throw Exception('Available Orders Error: $e');
    }
  }

  // ==============================
  // EMPLOYEE - ACCEPT ORDER
  // ==============================

  Future<Map<String, dynamic>> acceptOrder(
      String orderId, String employeeId) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/orders/accept/$orderId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'employee_id': employeeId,
            }),
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () =>
                throw Exception('Server timeout (Render may be waking up)'),
          );

      print("ACCEPT ORDER STATUS: ${response.statusCode}");
      print("ACCEPT ORDER RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to accept order');
      }
    } catch (e) {
      throw Exception('Accept Order Error: $e');
    }
  }
}