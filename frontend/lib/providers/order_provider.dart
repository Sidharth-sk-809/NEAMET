import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Order? _currentOrder;
  List<AvailableOrder> _availableOrders = [];
  Order? _activeDelivery;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPolling = false;

  Order? get currentOrder => _currentOrder;
  List<AvailableOrder> get availableOrders => _availableOrders;
  Order? get activeDelivery => _activeDelivery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> createOrder(
    String customerId,
    List<Map<String, dynamic>> items,
    double totalAmount,
    double deliveryDistance,
    double deliveryCost,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.createOrder(
        customerId,
        items,
        totalAmount,
        deliveryDistance,
        deliveryCost,
      );

      if (response['order'] != null) {
        _currentOrder = Order.fromJson(response['order']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Invalid order response');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> pollOrderStatus(String orderId) async {
    if (_isPolling) return;
    _isPolling = true;

    while (_isPolling && _currentOrder?.status != 'delivered') {
      try {
        _currentOrder = await _apiService.getOrderStatus(orderId);
        notifyListeners();
        
        // Stop polling if delivered
        if (_currentOrder?.status == 'delivered') {
          _isPolling = false;
          break;
        }
        
        // Wait 5 seconds before next poll
        await Future.delayed(const Duration(seconds: 5));
      } catch (e) {
        _isPolling = false;
        break;
      }
    }
  }

  void stopPolling() {
    _isPolling = false;
  }

  Future<bool> fetchAvailableOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _availableOrders = await _apiService.getAvailableOrders();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> acceptOrder(String orderId, String employeeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.acceptOrder(orderId, employeeId);
      
      if (response['order'] != null) {
        _activeDelivery = Order.fromJson(response['order']);
        // Remove from available orders
        _availableOrders.removeWhere((order) => order.id == orderId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to accept order');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchActiveDelivery(String employeeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activeDelivery = await _apiService.getActiveDelivery(employeeId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = null; // Don't show error if no active delivery
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetOrder() {
    _currentOrder = null;
    _isPolling = false;
    notifyListeners();
  }
}
