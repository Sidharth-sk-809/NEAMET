# NEAMET Flutter App - Quick Start Guide

## Prerequisites

- Flutter SDK (3.0+)
- Dart SDK
- Android Studio or Xcode
- Emulator or physical device

## Setup Instructions

### 1. Get Flutter

```bash
# Check Flutter installation
flutter doctor

# Update Flutter if needed
flutter upgrade
```

### 2. Clone/Setup Project

```bash
cd frontend
flutter pub get
```

### 3. Run the App

```bash
# Run with default emulator/device
flutter run

# Run with verbose logging
flutter run -v

# Run on specific device
flutter run -d <device_id>
```

### 4. Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Project Structure

```
lib/
├── main.dart                    # App entry & routing
├── models/                      # Data models
├── services/                    # API integration
├── providers/                   # State management
├── screens/                     # Page screens
├── widgets/                     # Reusable components
└── utils/                       # Theme & constants
```

## Key Files to Know

| File | Purpose |
|------|---------|
| lib/main.dart | App initialization, routing |
| lib/utils/theme.dart | Design system, colors, spacing |
| lib/services/api_service.dart | Backend API calls |
| lib/providers/* | State management |

## Common Commands

```bash
# Format code
dart format lib/

# Analyze code
dart analyze

# Run tests
flutter test

# Clean build
flutter clean

# Get package updates
flutter pub upgrade
```

## Debugging Tips

### Hot Reload
- Press `r` during `flutter run` to reload code without restarting app
- Press `R` for full restart

### Inspector
- Press `i` to launch widget inspector
- Shows widget tree and properties

### Console Logs
```dart
print('Debug message');
debugPrint('Safe debug');
```

### Error Messages
- Check terminal output for detailed error logs
- Use `flutter run -v` for verbose output

## Testing the Features

### Customer Path
1. Login with email: `customer@example.com`, password: `password`
2. Search products (try "apple", "milk")
3. Use distance filters (2km, 5km, 10km)
4. Add products to cart
5. View grouped cart items
6. Place order
7. Track delivery status

### Employee Path
1. Login with email: `employee@example.com`, password: `password`
2. View available orders
3. Click "Accept Order"
4. View delivery details
5. Track and manage earnings

## API Endpoints

Base URL: `https://neamet-backend.onrender.com`

- POST `/login` - User authentication
- GET `/products/search?q=&range=` - Search products
- POST `/order/create` - Create order
- GET `/order/status/{order_id}` - Track order
- GET `/orders/available` - Available orders
- POST `/orders/accept/{order_id}` - Accept order

## Troubleshooting

### Device Not Recognized
```bash
flutter devices
adb devices  # Android
```

### Build Fails
```bash
flutter clean
flutter pub get
flutter run
```

### Hot Reload Not Working
- Exit app (Press `q`)
- Run `flutter run` again

### API Not Connecting
- Check internet connection
- Verify backend is running
- Check API base URL in `api_service.dart`

### Dependency Issues
```bash
flutter pub get
flutter pub upgrade
```

## State Management Flow

```
AuthProvider
  └─ Manages login/logout
  
ProductProvider
  └─ Manages search & filters
  
CartProvider
  └─ Manages cart items & totals
  
OrderProvider
  └─ Manages order creation & polling
```

## Performance Optimization

- Uses `Consumer` for targeted rebuilds
- Images cached with `cached_network_image`
- Shimmer loaders for smooth UX
- Debounced search to reduce API calls

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design](https://material.io/design)

## Next Steps

1. Run the app locally
2. Test both customer and employee flows
3. Check console for any errors
4. Monitor network requests in DevTools
5. Deploy to testing device/emulator

## Support

For issues:
1. Check terminal output for error messages
2. Run with `-v` flag for verbose logs
3. Clear cache: `flutter clean && flutter pub get`
4. Restart device/emulator
5. Check backend API status

Happy coding! 🚀
