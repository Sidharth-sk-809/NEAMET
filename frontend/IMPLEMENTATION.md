# NEAMET Flutter App - Implementation Guide

## Overview

This is a complete, production-ready Flutter application for the NEAMET grocery delivery platform. The app has two distinct user interfaces based on role:
- **Customer**: Browse products, manage cart, track orders
- **Employee**: Accept deliveries, track active orders, earn money

## Architecture

### 1. Provider State Management

The app uses **Provider** for reactive state management with four main providers:

#### AuthProvider
```dart
- currentUser: User? 
- isAuthenticated: bool
- isCustomer: bool
- isEmployee: bool

Methods:
- login(email, password) -> Future<bool>
- logout()
```

**Responsibility**: Manages user authentication, role detection, and session management.

#### ProductProvider
```dart
- products: List<Product>
- searchResults: List<Product>
- isLoading: bool
- currentDistanceRange: int

Methods:
- fetchAllProducts() -> Future<void>
- searchProducts(query) -> Future<void>
- updateDistanceRange(range) -> Future<void>
```

**Responsibility**: Manages product listing, search, and distance filtering.

#### CartProvider
```dart
- cart: Cart
- itemCount: int
- totalProductPrice: double
- deliveryCost: double
- grandTotal: double

Methods:
- addToCart(product)
- removeFromCart(productId)
- updateQuantity(productId, quantity)
- clearCart()
- getOrderItems() -> List<Map>
```

**Responsibility**: Manages multi-shop cart with quantity updates and calculations.

#### OrderProvider
```dart
- currentOrder: Order?
- availableOrders: List<AvailableOrder>
- activeDelivery: Order?
- isLoading: bool

Methods:
- createOrder(...) -> Future<bool>
- pollOrderStatus(orderId) -> Future<void>
- fetchAvailableOrders() -> Future<bool>
- acceptOrder(orderId, employeeId) -> Future<bool>
- fetchActiveDelivery(employeeId) -> Future<bool>
```

**Responsibility**: Manages order creation, status polling, and employee order assignment.

### 2. Data Models

#### User
- id, email, role, name, phone

#### Product
- id, name, shopName, shopCategory, price, distance
- imageUrl, description, quantity

#### CartItem
- product: Product
- quantity: int

#### Cart
- items: List<CartItem>
- Grouped by shop functionality
- Automatic calculations (total, delivery cost)

#### Order & OrderItem
- Complete order tracking
- Employee assignment (name, code, delivery cost)

#### AvailableOrder (For Employees)
- Order ID, shops involved, product count
- Distance and earnings calculation

### 3. API Service

Single centralized API service with organized methods:

```
Authentication: login()
Products: searchProducts(), getAllProducts()
Cart: getCart()
Orders: createOrder(), getOrderStatus()
Employee: getAvailableOrders(), acceptOrder(), getActiveDelivery()
```

All network calls include:
- 10-second timeout handling
- Exception wrapping for UI
- Proper JSON parsing

### 4. Screen Architecture

#### Login Screen
- Email/password inputs with validation
- Error message display
- Demo credentials hint
- Role-based navigation

#### Customer Home Screen
- Greeting message
- Search bar (real-time)
- Distance filter chips (2/5/10 km)
- Product grid (2 columns)
- Floating action button for cart
- Loading and error states

#### Cart Screen
- Items grouped by shop
- Quantity controls
- Summary card with costs breakdown
- Confirm purchase dialog
- Continue shopping button

#### Order Status Screen
- Live order tracking
- Delivery partner info
- Order items breakdown
- Status updates every 5 seconds
- Status badges (Waiting/Out for Delivery/Delivered)

#### Employee Dashboard
- Available orders list
- Order card with details
- Accept button with loading state
- Refresh functionality
- Empty state handling

#### Delivery Screen
- Active delivery tracking
- Customer and order details
- Earnings display
- Order items list
- Back to available orders button

### 5. Styling & Theme

Centralized theme in `utils/theme.dart`:

**Colors**
- Primary: #22C55E (Green)
- Dark Green: #16A34A
- Light Green: #F0FDF4
- Background: #FFFFFF
- Surface: #FAFAFA
- Text Primary: #1F2937
- Text Secondary: #6B7280
- Border: #E5E7EB
- Error: #EF4444

**Spacing Scale**
- XSmall: 4
- Small: 8
- Medium: 12
- Large: 16
- XLarge: 20
- XXLarge: 24

**Border Radius**
- Small: 8
- Medium: 12
- Large: 16
- XLarge: 20
- XXLarge: 22

**Shadows**: Soft shadows for depth without heaviness

### 6. Widget Reusability

#### ProductCard
Displays product with image, shop info, price, distance badge, add button

#### CartItemWidget
Shows cart item with quantity controls, remove option

#### ShopGroupWidget
Groups cart items by shop with header and items list

#### SummaryCard
Displays cost breakdown (product total, distance, delivery, grand total)

#### OrderCard
Shows order details for employee with accept button

#### LoadingShimmer & ProductCardShimmer
Placeholder animations during loading

#### EmptyStateWidget & ErrorWidget
Consistent empty/error states across app

## Key Features Implementation

### Multi-Shop Cart
The `Cart` model automatically groups items by shop:
```dart
List<ShopGroup> get groupedByShop {
  // Groups items by shopName
  // Each shop shows its items separately
}
```

### Distance-Based Delivery Cost
```dart
double get deliveryCost => totalDistance * 10;
// Cost = Distance × 10 (as per spec)
```

### Product Search with Filters
- Real-time search (onChange)
- Distance range filtering (2/5/10 km)
- Client-side filtering + API search

### Order Status Polling
```dart
Future<void> pollOrderStatus(String orderId) async {
  // Polls every 5 seconds
  // Stops when delivered
  // Updates UI in real-time
}
```

### Role-Based Navigation
AuthWrapper checks user role and shows:
- LoginScreen → if not authenticated
- CustomerHomeScreen → if customer
- EmployeeDashboardScreen → if employee

## API Flow Diagrams

### Customer Flow
```
Login → Home (fetch products) → Search/Filter → 
Add to Cart → Cart Screen → Confirm → 
Order Status (polling) → View Items → Home
```

### Employee Flow
```
Login → Dashboard (fetch available orders) → 
Accept Order → Delivery Screen → View Details → 
Back to Dashboard
```

## Error Handling

All screens implement:
1. **Loading States**: Shimmer or progress indicators
2. **Error States**: Helpful messages with retry buttons
3. **Empty States**: Contextual empty icons and messages
4. **Validation**: Input validation with feedback

## Performance Optimizations

1. **Grid View**: Uses SliverGridDelegate for efficient rendering
2. **Image Caching**: cached_network_image for image optimization
3. **Lazy Loading**: Products loaded on demand
4. **Provider Efficiency**: Selective rebuilds with Consumer
5. **Debounced Search**: Real-time search without excessive API calls

## Testing the Application

### Demo Credentials
```
Customer: customer@example.com / password
Employee: employee@example.com / password
```

### Test Flows

**Customer**:
1. Login with customer credentials
2. Search for products (e.g., "apple")
3. Change distance filters (2km, 5km, 10km)
4. Add multiple products from different shops
5. View cart (grouped by shop)
6. Adjust quantities
7. Place order
8. Monitor delivery status

**Employee**:
1. Login with employee credentials
2. View available orders
3. Accept an order
4. View active delivery details
5. Track customer and earnings

## Future Enhancements

1. **Real-time Location Tracking**: Maps integration for delivery routes
2. **Payment Gateway**: Stripe/Razorpay integration
3. **Push Notifications**: Firebase Cloud Messaging
4. **Ratings & Reviews**: Customer feedback system
5. **Saved Addresses**: Multiple delivery addresses
6. **Offline Support**: Local caching with Hive
7. **Dark Mode**: Theme switching
8. **Internationalization**: Multi-language support

## Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Code Quality

- Clean architecture with separation of concerns
- Reusable widgets and components
- Type-safe with null safety
- Organized folder structure
- Comprehensive error handling
- Consistent naming conventions

## Troubleshooting

1. **API Connection Issues**: Check backend URL and network connectivity
2. **Loading Spinner Stuck**: May indicate API timeout - check backend logs
3. **Cart Not Updating**: Verify CartProvider is properly initialized
4. **Search Not Working**: Check query parameter formatting in API service

This implementation provides a solid foundation for a production-grade delivery application with room for scaling and additional features.
