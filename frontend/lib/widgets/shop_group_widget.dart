import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../utils/theme.dart';
import 'cart_item_widget.dart';

class ShopGroupWidget extends StatelessWidget {
  final ShopGroup shopGroup;
  final Function(String, int) onQuantityChanged;
  final Function(String) onRemove;

  const ShopGroupWidget({
    Key? key,
    required this.shopGroup,
    required this.onQuantityChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shop header
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLarge,
            vertical: AppTheme.spacingMedium,
          ),
          decoration: BoxDecoration(
            color: AppTheme.lightGreen,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radiusLarge),
              topRight: Radius.circular(AppTheme.radiusLarge),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shopGroup.shopName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                shopGroup.shopCategory,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkGreen,
                    ),
              ),
            ],
          ),
        ),
        // Items
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppTheme.radiusLarge),
              bottomRight: Radius.circular(AppTheme.radiusLarge),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: shopGroup.items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.borderColor,
            ),
            itemBuilder: (context, index) {
              final item = shopGroup.items[index];
              return Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMedium),
                child: CartItemWidget(
                  item: item,
                  onQuantityChanged: (quantity) =>
                      onQuantityChanged(item.product.id, quantity),
                  onRemove: () => onRemove(item.product.id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
