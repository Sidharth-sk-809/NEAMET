import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/custom_error_widget.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final employeeId =
          context.read<AuthProvider>().currentUser?.id ?? 'employee_1';
      context.read<OrderProvider>().fetchActiveDelivery(employeeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Active Delivery'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppTheme.spacingLarge),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text(
                          'Are you sure you want to logout?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.read<AuthProvider>().logout();
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.errorColor,
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(
                  Icons.logout,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        body: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            final delivery = orderProvider.activeDelivery;

            if (delivery == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),
                    Text(
                      'Fetching delivery details...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.spacingXLarge),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusXLarge),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              AppTheme.spacingMedium,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.local_shipping,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          Text(
                            'Out for Delivery',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          Text(
                            'Order #${delivery.id}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.darkGreen,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),

                    // Customer info
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingLarge),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusXLarge),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  AppTheme.spacingMedium,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacingMedium),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Customer ID: ${delivery.customerId}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    delivery.createdAt.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),

                    // Delivery details
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingLarge),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusXLarge),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Details',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          _buildDetailRow(
                            context,
                            'Delivery Distance',
                            AppConstants.formatDistance(
                              delivery.deliveryDistance,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          _buildDetailRow(
                            context,
                            'Earnings',
                            AppConstants.formatCurrency(delivery.deliveryCost),
                            isBold: true,
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          _buildDetailRow(
                            context,
                            'Total Amount',
                            AppConstants.formatCurrency(delivery.totalAmount),
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          _buildDetailRow(
                            context,
                            'Est. Time',
                            delivery.estimatedDeliveryTime ?? '5 hours',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),

                    // Items
                    Text(
                      'Items (${delivery.items.length})',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    ...delivery.items.map((item) {
                      return Container(
                        padding: const EdgeInsets.all(AppTheme.spacingMedium),
                        margin: const EdgeInsets.only(
                          bottom: AppTheme.spacingMedium,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusLarge),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.shopName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingMedium),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'x${item.quantity}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppConstants.formatCurrency(item.subtotal),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppTheme.primaryGreen,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: AppTheme.spacingXLarge),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<OrderProvider>().resetOrder();
                          Navigator.of(context).pushReplacementNamed(
                            '/employee-dashboard',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.spacingLarge,
                          ),
                        ),
                        child: const Text(
                          'Back to Available Orders',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                color: isBold ? AppTheme.primaryGreen : AppTheme.textPrimary,
              ),
        ),
      ],
    );
  }
}
