# NEAMET App Architecture Diagram

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUTTER APPLICATION                       │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              PRESENTATION LAYER (Screens)             │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │  • LoginScreen                                        │  │
│  │  • CustomerHomeScreen                                │  │
│  │  • CartScreen                                        │  │
│  │  • OrderStatusScreen                                 │  │
│  │  • EmployeeDashboardScreen                           │  │
│  │  • DeliveryScreen                                    │  │
│  └───────────────────────────────────────────────────────┘  │
│                          ↓ ↑                                 │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              WIDGET LAYER (Reusable)                  │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │  • ProductCard          • LoadingShimmer             │  │
│  │  • CartItemWidget       • ErrorWidget                │  │
│  │  • ShopGroupWidget      • OrderCard                  │  │
│  │  • SummaryCard          • EmptyStateWidget           │  │
│  └───────────────────────────────────────────────────────┘  │
│                          ↓ ↑                                 │
│  ┌───────────────────────────────────────────────────────┐  │
│  │        STATE MANAGEMENT LAYER (Providers)             │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │                                                       │  │
│  │  ┌──────────────┐  ┌──────────────┐                  │  │
│  │  │ AuthProvider │  │ProductProvider                 │  │
│  │  │              │  │                                │  │
│  │  │ • currentUser│  │ • products   │                 │  │
│  │  │ • isLoading  │  │ • searchQuery│                 │  │
│  │  │ • login()    │  │ • search()   │                 │  │
│  │  └──────────────┘  └──────────────┘                  │  │
│  │                                                       │  │
│  │  ┌──────────────┐  ┌──────────────┐                  │  │
│  │  │CartProvider  │  │OrderProvider │                  │  │
│  │  │              │  │               │                 │  │
│  │  │ • cart items │  │ • currentOrder                 │  │
│  │  │ • addToCart()│  │ • pollStatus()                 │  │
│  │  │ • clearCart()│  │ • createOrder()                │  │
│  │  └──────────────┘  └──────────────┘                  │  │
│  │                                                       │  │
│  └───────────────────────────────────────────────────────┘  │
│                          ↓ ↑                                 │
│  ┌───────────────────────────────────────────────────────┐  │
│  │            BUSINESS LOGIC LAYER (Services)            │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │                   API Service                         │  │
│  │  • login()                                           │  │
│  │  • searchProducts()                                  │  │
│  │  • createOrder()                                     │  │
│  │  • pollOrderStatus()                                 │  │
│  │  • fetchAvailableOrders()                            │  │
│  │  • acceptOrder()                                     │  │
│  └───────────────────────────────────────────────────────┘  │
│                          ↓ ↑                                 │
│  ┌───────────────────────────────────────────────────────┐  │
│  │         DATA LAYER (Models & Constants)               │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │ • User         • Cart         • Order                │  │
│  │ • Product      • CartItem     • OrderItem            │  │
│  │ • Theme        • Constants                           │  │
│  └───────────────────────────────────────────────────────┘  │
│                          ↓ ↑                                 │
└─────────────────────────────────────────────────────────────┘
                          ↓ ↑
        ┌──────────────────────────────────┐
        │  Backend API (neamet-backend)    │
        │  https://neamet-backend.onrender │
        └──────────────────────────────────┘
```

## User Flow Diagram

### Customer Journey

```
┌──────────────┐
│   Login      │
│ (Email/Pass) │
└──────┬───────┘
       │
       ↓
┌──────────────────────┐
│  CustomerHomeScreen  │
│  - Browse Products   │
│  - Search            │
│  - Filter Distance   │
└──────┬───────────────┘
       │
       ├─→ ProductProvider.fetchAllProducts()
       │
       ↓
┌──────────────────────┐
│  Add to Cart         │
│  (CartProvider)      │
└──────┬───────────────┘
       │
       ↓
┌──────────────────────┐
│  CartScreen          │
│  - View Items        │
│  - Modify Qty        │
│  - Summary Card      │
└──────┬───────────────┘
       │
       ├─→ CartProvider.updateQuantity()
       │
       ↓
┌──────────────────────┐
│  Place Order         │
│  (Confirmation)      │
└──────┬───────────────┘
       │
       ├─→ OrderProvider.createOrder()
       │
       ↓
┌──────────────────────┐
│  OrderStatusScreen   │
│  - Polling (5s)      │
│  - Track Delivery    │
│  - View Delivery Boy │
└──────┬───────────────┘
       │
       ├─→ OrderProvider.pollOrderStatus() [Loop]
       │
       ↓
┌──────────────────────┐
│  Delivered           │
│  Back to Home        │
└──────────────────────┘
```

### Employee Journey

```
┌──────────────┐
│   Login      │
│ (Email/Pass) │
└──────┬───────┘
       │
       │ (Role: Employee)
       ↓
┌──────────────────────────────┐
│  EmployeeDashboardScreen     │
│  - Available Orders List     │
│  - Distance & Earnings       │
│  - Refresh Button            │
└──────┬───────────────────────┘
       │
       ├─→ OrderProvider.fetchAvailableOrders()
       │
       ↓
┌──────────────────────────────┐
│  Select Order                │
│  Accept Order Button         │
└──────┬───────────────────────┘
       │
       ├─→ OrderProvider.acceptOrder()
       │
       ↓
┌──────────────────────────────┐
│  DeliveryScreen              │
│  - Customer ID               │
│  - Distance & Earnings       │
│  - Order Items               │
│  - Status: Out for Delivery  │
└──────┬───────────────────────┘
       │
       │
       ↓
┌──────────────────────────────┐
│  Back to Dashboard           │
│  Accept Next Order           │
└──────────────────────────────┘
```

## Provider Dependency Graph

```
                    ┌─────────────┐
                    │ AuthProvider│ (User Identity)
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ↓                  ↓                  ↓
  ┌──────────────┐  ┌──────────────┐  ┌────────────────┐
  │ProductProvider   CartProvider  │  │ OrderProvider   │
  │- search()   │  │- addToCart() │  │ - createOrder() │
  │- filter()   │  │- update()    │  │ - pollStatus()  │
  └──────────────┘  └──────────────┘  └────────────────┘
```

## API Call Flow

```
┌─────────────────────────────────────────┐
│         App UI (Screens/Widgets)        │
└────────────────────┬────────────────────┘
                     │
                     ↓
         ┌──────────────────────┐
         │  Provider Methods    │
         │  (Business Logic)    │
         └────────────┬─────────┘
                      │
                      ↓
         ┌──────────────────────┐
         │   ApiService         │
         │  (HTTP Requests)     │
         └────────────┬─────────┘
                      │
            ┌─────────┴─────────┐
            │                   │
            ↓                   ↓
     ┌─────────────┐      ┌──────────────┐
     │   Request   │      │ JSON Parse   │
     │   HTTP/1.1  │      │  Response    │
     └─────────────┘      └──────────────┘
            │                   │
            └─────────┬─────────┘
                      │
                      ↓
     ┌──────────────────────────────┐
     │ Backend API                  │
     │ neamet-backend.onrender.com  │
     └──────────────────────────────┘
                      │
            ┌─────────┴─────────┐
            │                   │
            ↓                   ↓
     ┌─────────────┐      ┌──────────────┐
     │ Database    │      │  Processing  │
     │ Operations  │      │  Business    │
     └─────────────┘      └──────────────┘
            │                   │
            └─────────┬─────────┘
                      │
                      ↓
        ┌──────────────────────┐
        │ JSON Response        │
        │ HTTP/1.1 200         │
        └────────────┬─────────┘
                     │
                     ↓
        ┌──────────────────────┐
        │  Provider Updates    │
        │  notifyListeners()   │
        └────────────┬─────────┘
                     │
                     ↓
        ┌──────────────────────┐
        │  UI Rebuilds         │
        │  Consumer Widgets    │
        │  setState()          │
        └──────────────────────┘
```

## State Management Flow

```
┌──────────────────────────────────────┐
│      Event (User Action)             │
│  e.g., Button tap, input, etc.       │
└──────────────┬───────────────────────┘
               │
               ↓
     ┌─────────────────────┐
     │  Provider Method    │
     │  e.g., login()      │
     └────────┬────────────┘
              │
              ├─→ Update state variables
              │   _isLoading = true
              │
              ├─→ Call service/API
              │   await apiService.call()
              │
              ├─→ Handle response/error
              │   Update _data, _error
              │
              └─→ Notify listeners
                  notifyListeners()
                      │
                      ↓
              ┌──────────────────┐
              │ Rebuild Consumers│
              │ using build()    │
              └──────────────────┘
                      │
                      ↓
              ┌──────────────────┐
              │ New UI rendered  │
              │ with new state   │
              └──────────────────┘
```

## Data Model Relationships

```
┌──────────────┐
│    User      │
├──────────────┤
│ - id         │
│ - email      │
│ - role       │
│ - name       │
│ - phone      │
└──────────────┘

        ↓ (owns)

┌──────────────┐         ┌──────────────┐
│    Cart      │ ←─→     │    Product   │
├──────────────┤         ├──────────────┤
│ - items[]    │         │ - id         │
│ - totals     │         │ - name       │
│ - groups[]   │         │ - price      │
└──────────────┘         │ - shop       │
       │                 │ - distance   │
       │ (contains)      │ - image      │
       │                 └──────────────┘
       │
       └─→ ┌──────────────┐
           │  CartItem    │
           ├──────────────┤
           │ - product    │
           │ - quantity   │
           └──────────────┘
                    │
                    │ (part of)
                    ↓
           ┌──────────────┐
           │  ShopGroup   │
           ├──────────────┤
           │ - shopName   │
           │ - items[]    │
           │ - subtotal   │
           └──────────────┘

┌──────────────┐
│    Order     │
├──────────────┤
│ - id         │
│ - customerId │
│ - status     │
│ - items[]    │
│ - total      │
│ - employee   │
└──────────────┘
       │
       └─→ ┌──────────────┐
           │  OrderItem   │
           ├──────────────┤
           │ - productId  │
           │ - name       │
           │ - price      │
           │ - quantity   │
           └──────────────┘
```

This architecture demonstrates professional-grade Flutter app structure with proper separation of concerns and scalable design.
