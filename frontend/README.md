# NEAMET Flutter Frontend

Modern grocery delivery app built with Flutter and Provider state management.

## Features

✅ **User Authentication**
- Login for customers and delivery partners
- Role-based navigation

✅ **Customer Features**
- Product search with distance filtering (2km, 5km, 10km)
- Multi-shop cart management
- Price comparison across shops
- Real-time order status tracking
- Distance-based delivery cost calculation

✅ **Employee/Delivery Partner Features**
- Available orders dashboard
- Accept orders and earn based on delivery distance
- Active delivery tracking
- Order details and customer information

✅ **UI/UX Design**
- Modern, clean design with rounded corners
- Soft shadows and minimal colors
- Green accent color for primary actions
- Responsive grid layout for products
- Loading states and error handling

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── user_model.dart
│   ├── product_model.dart
│   ├── cart_model.dart
│   └── order_model.dart
├── services/
│   └── api_service.dart      # Backend API integration
├── providers/
│   ├── auth_provider.dart
│   ├── product_provider.dart
│   ├── cart_provider.dart
│   └── order_provider.dart
├── screens/
│   ├── login_screen.dart
│   ├── customer_home.dart
│   ├── cart_screen.dart
│   ├── order_status_screen.dart
│   ├── employee_dashboard.dart
│   └── delivery_screen.dart
├── widgets/
│   ├── product_card.dart
│   ├── cart_item_widget.dart
│   ├── shop_group_widget.dart
│   ├── summary_card.dart
│   ├── order_card.dart
│   ├── loading_shimmer.dart
│   └── error_widget.dart
└── utils/
    ├── theme.dart            # App theme and colors
    └── constants.dart        # Constants and formatting
```

## Setup & Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode (for iOS development)

### Installation Steps

1. **Install dependencies**
```bash
flutter pub get
```

2. **Run the app**
```bash
flutter run
```

3. **Build for production**
```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## Configuration

Update API base URL in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://neamet-backend.onrender.com';
```

## Demo Credentials

- **Customer**: customer@example.com / password
- **Employee**: employee@example.com / password

## API Integration

The app communicates with the backend at:
```
https://neamet-backend.onrender.com
```

### Key Endpoints Used:
- POST `/login` - User authentication
- GET `/products/search?q=&range=` - Product search
- POST `/order/create` - Create order
- GET `/order/status/{order_id}` - Order status polling
- GET `/orders/available` - Available orders for employees
- POST `/orders/accept/{order_id}` - Accept order

## State Management

Using **Provider** package for:
- Authentication state
- Product list and search results
- Shopping cart management
- Order tracking and polling

## UI Design Principles

- **Border Radius**: 16-22dp for cards
- **Spacing**: Consistent 4-24dp scale
- **Colors**: Green primary (#22C55E), white background
- **Shadows**: Soft, minimal shadows for depth
- **Icons**: Material Design icons throughout

## Build Process

The app uses Flutter's standard build system with proper:
- Platform channels setup
- Dependency management via pubspec.yaml
- Proper Android/iOS configurations

## Debugging

Enable verbose logging:
```bash
flutter run -v
```

Run tests:
```bash
flutter test
```

## Performance Considerations

- Image caching with cached_network_image
- Shimmer loading states for smooth UX
- Efficient Provider architecture
- Debounced search input
- Polling for order status updates

## Future Enhancements

- Push notifications for order updates
- Real-time location tracking
- Payment gateway integration
- Customer ratings and reviews
- Saved addresses and preferences
- Multiple language support

## License

Private project for NEAMET
