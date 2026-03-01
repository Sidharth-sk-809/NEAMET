"""Schemas package for NEAMET backend - Legacy & Order Management."""

# Legacy schemas (auth, products, cart)
from app.schemas.legacy import (
    LoginRequest,
    LoginResponse,
    ProductSearchItem,
    ProductSearchResponse,
    CartAddRequest,
    CartItemView,
    CartResponse,
    OrderCreateRequest,
    OrderCreateResponse,
    OrderSummary,
    OrderAcceptRequest,
    OrderStatusResponse,
)

# Order management schemas
from app.schemas.order import (
    OrderCreate,
    OrderCreateResponse as OrderCreateResponseNew,
    OrderResponse,
    OrderItemCreate,
    OrderItemResponse,
    OrderStatusUpdate,
)

__all__ = [
    # Legacy schemas
    "LoginRequest",
    "LoginResponse",
    "ProductSearchItem",
    "ProductSearchResponse",
    "CartAddRequest",
    "CartItemView",
    "CartResponse",
    "OrderCreateRequest",
    "OrderCreateResponse",
    "OrderSummary",
    "OrderAcceptRequest",
    "OrderStatusResponse",
    # Order management schemas
    "OrderCreate",
    "OrderCreateResponseNew",
    "OrderResponse",
    "OrderItemCreate",
    "OrderItemResponse",
    "OrderStatusUpdate",
]
