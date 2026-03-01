import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/order_provider.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/order_card.dart';
import '../widgets/custom_error_widget.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  late Future<void> _fetchOrdersFuture;

  @override
  void initState() {
    super.initState();
    _fetchOrdersFuture = context.read<OrderProvider>().fetchAvailableOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'NEAMET',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.w800,
              ),
        ),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return Padding(
                padding: const EdgeInsets.only(right: AppTheme.spacingLarge),
                child: InkWell(
                  onTap: () {
                    authProvider.logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: const Icon(
                    Icons.logout,
                    color: AppTheme.textPrimary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<OrderProvider>().fetchAvailableOrders(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return Text(
                          'Hello, ${authProvider.currentUser?.name ?? 'Delivery Partner'}!',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Text(
                      'Available Orders',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXLarge),

                // Orders list
                Consumer<OrderProvider>(
                  builder: (context, orderProvider, _) {
                    if (orderProvider.isLoading) {
                      return _buildLoadingState();
                    }

                    if (orderProvider.errorMessage != null) {
                      return AppErrorStateWidget(
                        message: orderProvider.errorMessage!,
                        onRetry: () =>
                            orderProvider.fetchAvailableOrders(),
                      );
                    }

                    if (orderProvider.availableOrders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            const Icon(
                              Icons.inbox_outlined,
                              size: 80,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(height: AppTheme.spacingXLarge),
                            Text(
                              AppConstants.noOrdersAvailable,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppTheme.textPrimary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spacingMedium),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  orderProvider.fetchAvailableOrders(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orderProvider.availableOrders.length,
                      itemBuilder: (context, index) {
                        final order =
                            orderProvider.availableOrders[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppTheme.spacingMedium,
                          ),
                          child: OrderCard(
                            order: order,
                            isLoading: orderProvider.isLoading &&
                                orderProvider.availableOrders[index].id ==
                                    order.id,
                            onAccept: () {
                              _acceptOrder(
                                context,
                                order.id,
                                orderProvider,
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: AppTheme.spacingMedium,
          ),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              border: Border.all(color: AppTheme.borderColor),
            ),
          ),
        );
      },
    );
  }

  void _acceptOrder(
    BuildContext context,
    String orderId,
    OrderProvider orderProvider,
  ) async {
    final employeeId =
        context.read<AuthProvider>().currentUser?.id ?? 'employee_1';

    final success = await orderProvider.acceptOrder(orderId, employeeId);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order accepted!'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        // Navigate to active delivery
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
            '/delivery',
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(orderProvider.errorMessage ?? 'Failed to accept order'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
