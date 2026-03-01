import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isCustomer => _currentUser?.role == 'customer';
  bool get isEmployee => _currentUser?.role == 'employee';

  // ✅ FIXED LOGIN
  Future<bool> login(String id, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.login(id, password);

      print("LOGIN RESPONSE:");
      print(response);

      // ✅ backend returns flat JSON
      if (response['id'] != null &&
          response['role'] != null) {

        _currentUser = User.fromJson(response);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Invalid login response');
      }

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}