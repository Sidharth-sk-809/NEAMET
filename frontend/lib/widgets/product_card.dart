import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAddTap,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radiusXLarge),
              topRight: Radius.circular(AppTheme.radiusXLarge),
            ),
            child: Container(
              width: double.infinity,
              height: 160,
              color: AppTheme.surfaceColor,
              child: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    )
                  : _buildPlaceholder(),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingXSmall),
                      Text(
                        product.shopName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppTheme.spacingXSmall),
                      Text(
                        product.shopCategory,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  // Price and button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.formatCurrency(product.price),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryGreen,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingSmall,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.lightGreen,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSmall),
                            ),
                            child: Text(
                              AppConstants.formatDistance(product.distance),
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.primaryGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: onAddTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingMedium,
                            vertical: AppTheme.spacingSmall,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusLarge),
                          ),
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
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
          size: 40,
        ),
      ),
    );
  }
}
