import 'package:flutter/material.dart';
import '../utils/theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onRetry;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: AppTheme.spacingXLarge),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppTheme.spacingXLarge),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

class AppErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorStateWidget({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: AppTheme.spacingXLarge),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLarge,
            ),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppTheme.spacingXLarge),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ],
      ),
    );
  }
}
