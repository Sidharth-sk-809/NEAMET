import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/login_screen.dart';
import 'screens/customer_home.dart';
import 'screens/cart_screen.dart';
import 'screens/order_status_screen.dart';
import 'screens/employee_dashboard.dart';
import 'screens/delivery_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'NEAMET',
        theme: AppTheme.getThemeData(),
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/customer-home': (context) => const CustomerHomeScreen(),
          '/cart': (context) =>  CartScreen(),
          '/order-status': (context) => const OrderStatusScreen(),
          '/employee-dashboard': (context) =>
              const EmployeeDashboardScreen(),
          '/delivery': (context) => const DeliveryScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        if (authProvider.isCustomer) {
          return const CustomerHomeScreen();
        }

        if (authProvider.isEmployee) {
          return const EmployeeDashboardScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
