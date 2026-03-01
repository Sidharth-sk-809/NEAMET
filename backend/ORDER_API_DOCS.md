"""
ORDER MANAGEMENT SYSTEM - API DOCUMENTATION & TESTING GUIDE

This implementation provides a complete order management system for the NEAMET marketplace.

═══════════════════════════════════════════════════════════════════════════════════

ENDPOINTS SUMMARY
═══════════════════════════════════════════════════════════════════════════════════

1. POST /orders - Create Order
   Status: 201 Created
   
2. GET /orders - List Orders
   Query params: status (optional), limit, offset
   Status: 200 OK
   
3. GET /orders/{order_id} - Get Single Order
   Status: 200 OK or 404 Not Found
   
4. PATCH /orders/{order_id}/status - Update Status
   Status: 200 OK or 404 Not Found

═══════════════════════════════════════════════════════════════════════════════════

EXAMPLE REQUESTS & RESPONSES

═══════════════════════════════════════════════════════════════════════════════════

1. CREATE ORDER - POST /orders
────────────────────────────────────────────────────────────────────────────────

Request:
{
  "customer_id": "123e4567-e89b-12d3-a456-426614174000",
  "total_price": 60.0,
  "delivery_cost": 100.0,
  "grand_total": 160.0,
  "items": [
    {
      "product_id": "550e8400-e29b-41d4-a716-446655440001",
      "product_name": "Bandage",
      "shop_name": "Health Medical",
      "quantity": 3,
      "price": 10.0
    },
    {
      "product_id": "550e8400-e29b-41d4-a716-446655440002",
      "product_name": "Wheat Flour",
      "shop_name": "Grocery Store",
      "quantity": 1,
      "price": 50.0
    }
  ]
}

Response (201 Created):
{
  "order_id": "789e1234-e89b-12d3-a456-426614174999",
  "status": "pending"
}

Validation Rules:
✓ All items must have quantity > 0
✓ All prices must be > 0
✓ grand_total MUST equal total_price + delivery_cost
✓ At least 1 item required

═══════════════════════════════════════════════════════════════════════════════════

2. LIST ORDERS - GET /orders?status=pending
────────────────────────────────────────────────────────────────────────────────

Request Parameters:
- status: "pending" | "accepted" | "picked_up" | "delivered" (optional)
- limit: number (default: 100, max: 1000)
- offset: number (default: 0)

Example URL:
  GET /orders?status=pending&limit=10&offset=0

Response (200 OK):
[
  {
    "id": "789e1234-e89b-12d3-a456-426614174999",
    "customer_id": "123e4567-e89b-12d3-a456-426614174000",
    "total_price": 60.0,
    "delivery_cost": 100.0,
    "grand_total": 160.0,
    "status": "pending",
    "items": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440010",
        "product_id": "550e8400-e29b-41d4-a716-446655440001",
        "product_name": "Bandage",
        "shop_name": "Health Medical",
        "quantity": 3,
        "price": 10.0
      },
      {
        "id": "550e8400-e29b-41d4-a716-446655440011",
        "product_id": "550e8400-e29b-41d4-a716-446655440002",
        "product_name": "Wheat Flour",
        "shop_name": "Grocery Store",
        "quantity": 1,
        "price": 50.0
      }
    ],
    "created_at": "2024-03-01T10:30:45.123456"
  }
]

═══════════════════════════════════════════════════════════════════════════════════

3. GET SINGLE ORDER - GET /orders/{order_id}
────────────────────────────────────────────────────────────────────────────────

Request:
  GET /orders/789e1234-e89b-12d3-a456-426614174999

Response (200 OK):
{
  "id": "789e1234-e89b-12d3-a456-426614174999",
  "customer_id": "123e4567-e89b-12d3-a456-426614174000",
  "total_price": 60.0,
  "delivery_cost": 100.0,
  "grand_total": 160.0,
  "status": "pending",
  "items": [...],
  "created_at": "2024-03-01T10:30:45.123456"
}

Error Response (404 Not Found):
{
  "detail": "Order not found"
}

═══════════════════════════════════════════════════════════════════════════════════

4. UPDATE ORDER STATUS - PATCH /orders/{order_id}/status
────────────────────────────────────────────────────────────────────────────────

Request:
  PATCH /orders/789e1234-e89b-12d3-a456-426614174999/status
  
Body:
{
  "status": "accepted"
}

Valid Status Values:
- "pending" → "accepted" → "picked_up" → "delivered"

Response (200 OK):
{
  "id": "789e1234-e89b-12d3-a456-426614174999",
  "customer_id": "123e4567-e89b-12d3-a456-426614174000",
  "total_price": 60.0,
  "delivery_cost": 100.0,
  "grand_total": 160.0,
  "status": "accepted",
  "items": [...],
  "created_at": "2024-03-01T10:30:45.123456"
}

Error Response (404 Not Found):
{
  "detail": "Order not found"
}

Error Response (400 Bad Request - Invalid Status):
{
  "detail": "Status must be one of {'pending', 'accepted', 'picked_up', 'delivered'}, got 'invalid'"
}

═══════════════════════════════════════════════════════════════════════════════════

ARCHITECTURE OVERVIEW
═══════════════════════════════════════════════════════════════════════════════════

Database Layer (database.py)
        ↓
Models Layer (models/order.py)
  ├─ Order (SQLAlchemy model)
  └─ OrderItem (SQLAlchemy model with FK to Order)
        ↓
Schemas Layer (schemas/order.py)
  ├─ OrderCreate (request validation)
  ├─ OrderResponse (response formatting)
  └─ OrderStatusUpdate (status update request)
        ↓
Service Layer (services/order_service.py)
  └─ OrderService (business logic)
        ↓
Routes Layer (routers/order.py)
  └─ Router endpoints (FastAPI)

═══════════════════════════════════════════════════════════════════════════════════

KEY FEATURES
═══════════════════════════════════════════════════════════════════════════════════

✓ UUID primary keys (PostgreSQL)
✓ Cascade delete (orders → items)
✓ Proper validation (grand_total = total_price + delivery_cost)
✓ Status constraints (4 valid values)
✓ Pydantic v2 validation with custom validators
✓ Service layer for business logic separation
✓ Dependency injection (db session)
✓ Proper HTTP status codes (201, 200, 400, 404)
✓ Comprehensive error handling
✓ Response models for type safety
✓ Docstrings for all functions
✓ Indexed foreign keys for performance
✓ Transaction support for atomic operations

═══════════════════════════════════════════════════════════════════════════════════

TESTING WITH CURL
═══════════════════════════════════════════════════════════════════════════════════

1. Create Order:
curl -X POST "http://localhost:8000/orders" \\
  -H "Content-Type: application/json" \\
  -d '{
    "customer_id": "123e4567-e89b-12d3-a456-426614174000",
    "total_price": 60.0,
    "delivery_cost": 100.0,
    "grand_total": 160.0,
    "items": [
      {
        "product_id": "550e8400-e29b-41d4-a716-446655440001",
        "product_name": "Bandage",
        "shop_name": "Health Medical",
        "quantity": 3,
        "price": 10.0
      }
    ]
  }'

2. List Orders:
curl -X GET "http://localhost:8000/orders?status=pending" \\
  -H "Content-Type: application/json"

3. Get Single Order:
curl -X GET "http://localhost:8000/orders/789e1234-e89b-12d3-a456-426614174999" \\
  -H "Content-Type: application/json"

4. Update Status:
curl -X PATCH "http://localhost:8000/orders/789e1234-e89b-12d3-a456-426614174999/status" \\
  -H "Content-Type: application/json" \\
  -d '{"status": "accepted"}'

═══════════════════════════════════════════════════════════════════════════════════

DATABASE SCHEMA (PostgreSQL)
═══════════════════════════════════════════════════════════════════════════════════

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    total_price DOUBLE PRECISION NOT NULL,
    delivery_cost DOUBLE PRECISION NOT NULL,
    grand_total DOUBLE PRECISION NOT NULL,
    status VARCHAR NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    INDEX idx_customer_id (customer_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL,
    product_name VARCHAR NOT NULL,
    shop_name VARCHAR NOT NULL,
    quantity INTEGER NOT NULL,
    price DOUBLE PRECISION NOT NULL,
    INDEX idx_order_id (order_id),
    INDEX idx_product_id (product_id)
);

═══════════════════════════════════════════════════════════════════════════════════
"""
