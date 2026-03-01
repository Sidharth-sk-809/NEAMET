import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class OrderCard extends StatelessWidget {
  final AvailableOrder order;
  final VoidCallback onAccept;
  final bool isLoading;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onAccept,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [AppTheme.softShadow],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMedium,
                  vertical: AppTheme.spacingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  '${order.productCount} items',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          // Shops
          Text(
            'Shops:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: AppTheme.spacingSmall,
            children: order.shops
                .map(
                  (shop) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMedium,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusSmall),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Text(
                      shop,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          // Distance and earnings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distance',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.formatDistance(order.totalDistance),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Earnings',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.formatCurrency(order.earnings),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryGreen,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          // Accept button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Accept Order',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
