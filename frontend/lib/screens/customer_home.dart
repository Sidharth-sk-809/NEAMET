import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import '../widgets/product_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/custom_error_widget.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  late TextEditingController _searchController;
  int _selectedDistanceRange = 2;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchAllProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return Text(
                    'Hello, ${authProvider.currentUser?.name ?? 'Customer'}!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  );
                },
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context
                                .read<ProductProvider>()
                                .searchProducts('');
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                  context.read<ProductProvider>().searchProducts(value);
                },
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              
              // Distance filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      'Distance Filter:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    const SizedBox(width: AppTheme.spacingMedium),
                    ...AppConstants.distanceRanges.map((range) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: AppTheme.spacingSmall,
                        ),
                        child: FilterChip(
                          label: Text('${range}km'),
                          selected: _selectedDistanceRange == range,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedDistanceRange = range;
                              });
                              context
                                  .read<ProductProvider>()
                                  .updateDistanceRange(range);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXLarge),
              
              // Products grid
              Consumer2<ProductProvider, CartProvider>(
                builder: (context, productProvider, cartProvider, _) {
                  if (productProvider.isLoading) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.5,
                        crossAxisSpacing: AppTheme.spacingMedium,
                        mainAxisSpacing: AppTheme.spacingMedium,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) =>
                          const ProductCardShimmer(),
                    );
                  }

                  if (productProvider.errorMessage != null) {
                    return AppErrorStateWidget(
                      message: productProvider.errorMessage!,
                      onRetry: () =>
                          productProvider.fetchAllProducts(),
                    );
                  }

                  if (productProvider.searchResults.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          const Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(height: AppTheme.spacingXLarge),
                          Text(
                            AppConstants.noProductsFound,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: AppTheme.spacingMedium,
                      mainAxisSpacing: AppTheme.spacingMedium,
                    ),
                    itemCount: productProvider.searchResults.length,
                    itemBuilder: (context, index) {
                      final product =
                          productProvider.searchResults[index];
                      return ProductCard(
                        product: product,
                        onAddTap: () {
                          cartProvider.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.name} added to cart',
                              ),
                              duration:
                                  const Duration(milliseconds: 800),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.isEmpty) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
            backgroundColor: AppTheme.primaryGreen,
            label: Text(
              'Cart (${cartProvider.itemCount})',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
          );
        },
      ),
    );
  }
}
