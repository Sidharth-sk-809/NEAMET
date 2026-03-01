import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  List<Product> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentDistanceRange = 2;
  String _searchQuery = '';

  List<Product> get products => _products;
  List<Product> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentDistanceRange => _currentDistanceRange;
  String get searchQuery => _searchQuery;

  Future<void> fetchAllProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _apiService.getAllProducts(range: 2);
      _searchResults = _products;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        _searchResults = _products;
      } else {
        _searchResults = await _apiService.searchProducts(
          query,
          range: _currentDistanceRange,
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDistanceRange(int range) async {
    _currentDistanceRange = range;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_searchQuery.isEmpty) {
        _searchResults = _products
            .where((p) => p.distance <= range)
            .toList();
      } else {
        _searchResults = await _apiService.searchProducts(
          _searchQuery,
          range: range,
        );
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
