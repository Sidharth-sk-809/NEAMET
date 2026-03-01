import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            child: Container(
              width: 100,
              height: 100,
              color: AppTheme.surfaceColor,
              child: item.product.imageUrl != null
                  ? Image.network(
                      item.product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.product.shopName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppConstants.formatCurrency(item.subtotal),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    // Quantity controls
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.borderColor),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (item.quantity > 1) {
                                onQuantityChanged(item.quantity - 1);
                              } else {
                                onRemove();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Text(
                              '${item.quantity}',
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                onQuantityChanged(item.quantity + 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.surfaceColor,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppTheme.textSecondary,
          size: 24,
        ),
      ),
    );
  }
}
