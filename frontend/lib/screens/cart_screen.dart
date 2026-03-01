import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/shop_group_widget.dart';
import '../widgets/summary_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: AppTheme.spacingXLarge),
                  Text(
                    'Cart is empty',
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                  ),
                  const SizedBox(height: AppTheme.spacingMedium),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Continue Shopping'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: Column(
                children: [
                  // Cart items grouped by shop
                  ...cartProvider.groupedByShop.map((shopGroup) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppTheme.spacingLarge,
                      ),
                      child: ShopGroupWidget(
                        shopGroup: shopGroup,
                        onQuantityChanged: (productId, quantity) {
                          cartProvider.updateQuantity(productId, quantity);
                        },
                        onRemove: (productId) {
                          cartProvider.removeFromCart(productId);
                        },
                      ),
                    );
                  }).toList(),
                  
                  const SizedBox(height: AppTheme.spacingXLarge),
                  
                  // Summary
                  SummaryCard(
                    productTotal: cartProvider.totalProductPrice,
                    totalDistance: cartProvider.totalDistance,
                    deliveryCost: cartProvider.deliveryCost,
                    grandTotal: cartProvider.grandTotal,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXLarge),
                  
                  // Buy now button
                  Consumer2<OrderProvider, AuthProvider>(
                    builder: (context, orderProvider, authProvider, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: orderProvider.isLoading
                              ? null
                              : () {
                                  _showConfirmDialog(
                                    context,
                                    cartProvider,
                                    orderProvider,
                                    authProvider,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spacingLarge,
                            ),
                            backgroundColor: AppTheme.primaryGreen,
                          ),
                          child: orderProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Buy Now - ${AppConstants.formatCurrency(cartProvider.grandTotal)}',
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
                  
                  const SizedBox(height: AppTheme.spacingMedium),
                  
                  // Continue shopping
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingMedium,
                        ),
                      ),
                      child: const Text('Continue Shopping'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    CartProvider cartProvider,
    OrderProvider orderProvider,
    AuthProvider authProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grand Total: ${AppConstants.formatCurrency(cartProvider.grandTotal)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryGreen,
                    ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Text(
                'Items: ${cartProvider.itemCount}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Text(
                'Distance: ${AppConstants.formatDistance(cartProvider.totalDistance)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _placeOrder(
                  context,
                  cartProvider,
                  orderProvider,
                  authProvider,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeOrder(
    BuildContext context,
    CartProvider cartProvider,
    OrderProvider orderProvider,
    AuthProvider authProvider,
  ) async {
    try {
      final success = await orderProvider.createOrder(
        authProvider.currentUser?.id ?? 'customer_1',
        cartProvider.getOrderItems(),
        cartProvider.totalProductPrice,
        cartProvider.totalDistance,
        cartProvider.deliveryCost,
      );

      if (success && context.mounted) {
        cartProvider.clearCart();
        await Navigator.of(context).pushReplacementNamed(
          '/order-status',
          arguments: orderProvider.currentOrder?.id,
        );
      } else if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(orderProvider.errorMessage ?? 'Failed to place order'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
