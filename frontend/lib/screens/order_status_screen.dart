import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class OrderStatusScreen extends StatefulWidget {
  final String? orderId;

  const OrderStatusScreen({Key? key, this.orderId}) : super(key: key);

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderId = widget.orderId ??
          ModalRoute.of(context)?.settings.arguments as String?;
      if (orderId != null) {
        context.read<OrderProvider>().pollOrderStatus(orderId);
      }
    });
  }

  @override
  void dispose() {
    context.read<OrderProvider>().stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Order Status'),
          centerTitle: true,
        ),
        body: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            final order = orderProvider.currentOrder;

            if (order == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),
                    Text(
                      'Fetching order details...',
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
                    // Status header
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
                            child: Icon(
                              _getStatusIcon(order.status),
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          Text(
                            _getStatusText(order.status),
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
                            'Order #${order.id}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.darkGreen,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),

                    // Delivery Partner info (if assigned)
                    if (order.employeeName != null) ...[
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
                              'Delivery Partner',
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
                                      order.employeeName ?? '-',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Code: ${order.employeeCode ?? '-'}',
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
                      const SizedBox(height: AppTheme.spacingLarge),
                    ],

                    // Order details
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
                            'Order Details',
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
                            'Total Amount',
                            AppConstants.formatCurrency(order.totalAmount),
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          _buildDetailRow(
                            context,
                            'Distance',
                            AppConstants.formatDistance(order.deliveryDistance),
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          _buildDetailRow(
                            context,
                            'Delivery Cost',
                            AppConstants.formatCurrency(order.deliveryCost),
                          ),
                          const SizedBox(height: AppTheme.spacingMedium),
                          _buildDetailRow(
                            context,
                            'Estimated Time',
                            order.estimatedDeliveryTime ?? '5 hours',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),

                    // Order items
                    Text(
                      'Items (${order.items.length})',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacingMedium),
                    ...order.items.map((item) {
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

                    // Action buttons
                    if (order.status == 'delivered') ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<OrderProvider>().resetOrder();
                            Navigator.of(context).pushReplacementNamed(
                              '/customer-home',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacingLarge,
                            ),
                          ),
                          child: const Text(
                            'Back to Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
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
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'waiting':
        return Icons.schedule;
      case 'out_for_delivery':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'waiting':
        return 'Waiting for Delivery Partner';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      default:
        return 'Pending';
    }
  }
}
