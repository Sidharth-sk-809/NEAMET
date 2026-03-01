import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class SummaryCard extends StatelessWidget {
  final double productTotal;
  final double totalDistance;
  final double deliveryCost;
  final double grandTotal;

  const SummaryCard({
    Key? key,
    required this.productTotal,
    required this.totalDistance,
    required this.deliveryCost,
    required this.grandTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [AppTheme.softShadow],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        children: [
          _buildRow(
            context,
            'Product Total',
            AppConstants.formatCurrency(productTotal),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          _buildRow(
            context,
            'Total Distance',
            AppConstants.formatDistance(totalDistance),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          _buildRow(
            context,
            'Delivery Cost',
            AppConstants.formatCurrency(deliveryCost),
          ),
          Divider(
            color: AppTheme.borderColor,
            height: 1,
          ),
          _buildRow(
            context,
            'Grand Total',
            AppConstants.formatCurrency(grandTotal),
            isBold: true,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                color: isTotal ? AppTheme.primaryGreen : AppTheme.textSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isTotal ? AppTheme.primaryGreen : AppTheme.textPrimary,
              ),
        ),
      ],
    );
  }
}
