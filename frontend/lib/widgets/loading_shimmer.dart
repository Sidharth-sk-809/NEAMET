import 'package:flutter/material.dart';
import '../utils/theme.dart';

class LoadingShimmer extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const LoadingShimmer({
    Key? key,
    this.height = 20,
    this.width,
    this.borderRadius = AppTheme.radiusLarge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppTheme.borderColor),
      ),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radiusXLarge),
              topRight: Radius.circular(AppTheme.radiusXLarge),
            ),
            child: Container(
              width: double.infinity,
              height: 160,
              color: AppTheme.surfaceColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingShimmer(
                        height: 16,
                        width: 120,
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      LoadingShimmer(
                        height: 14,
                        width: 100,
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      LoadingShimmer(
                        height: 12,
                        width: 80,
                      ),
                    ],
                  ),
                  LoadingShimmer(
                    height: 40,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
