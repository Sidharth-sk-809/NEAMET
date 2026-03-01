import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingXLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // Logo
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingXLarge),
                  decoration: BoxDecoration(
                    color: AppTheme.lightGreen,
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusXXLarge),
                  ),
                  child: Text(
                    'NEAMET',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                  ),
                ),
                const SizedBox(height: 60),
                // Title
                Text(
                  'Welcome to NEAMET',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                Text(
                  'Smart price comparison for local stores',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Email field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                // Password field
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                const SizedBox(height: 10),
                // Error message
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    if (authProvider.errorMessage != null) {
                      return Container(
                        padding: const EdgeInsets.all(AppTheme.spacingMedium),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusLarge),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppTheme.errorColor,
                            ),
                            const SizedBox(width: AppTheme.spacingMedium),
                            Expanded(
                              child: Text(
                                authProvider.errorMessage!,
                                style:
                                    Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.errorColor,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 30),
                // Login button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () {
                                if (_emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please fill all fields',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                authProvider
                                    .login(
                                      _emailController.text,
                                      _passwordController.text,
                                    )
                                    .then((success) {
                                  if (success) {
                                    if (authProvider.isCustomer) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        '/customer-home',
                                      );
                                    } else if (authProvider.isEmployee) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                        '/employee-dashboard',
                                      );
                                    }
                                  }
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.spacingLarge,
                          ),
                          backgroundColor: AppTheme.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusLarge),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Login',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                // Demo credentials
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMedium),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Credentials',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      Text(
                        'Customer: customer@example.com / password',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Employee: employee@example.com / password',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
