import 'package:intl/intl.dart';

class AppConstants {
  // API
  static const String apiBaseUrl = 'https://neamet-backend.onrender.com';

  // Routes
  static const String loginRoute = '/login';
  static const String customerHomeRoute = '/customer-home';
  static const String cartRoute = '/cart';
  static const String orderStatusRoute = '/order-status';
  static const String employeeDashboardRoute = '/employee-dashboard';
  static const String deliveryRoute = '/delivery';

  // Distance ranges for filter
  static const List<int> distanceRanges = [2, 5, 10];

  // Formatting
  static String formatCurrency(double value) {
    return NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    ).format(value);
  }

  static String formatDistance(double distance) {
    return '${distance.toStringAsFixed(1)} km';
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
  }

  // Messages
  static const String noProductsFound = 'No products found';
  static const String noOrdersAvailable = 'No orders available at the moment';
  static const String noActiveDelivery = 'No active delivery';
  static const String somethingWentWrong = 'Something went wrong';
  static const String pleaseTryAgain = 'Please try again';
}
