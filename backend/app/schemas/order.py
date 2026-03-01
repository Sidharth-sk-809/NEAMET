"""
Pydantic schemas for Order Management.

Request and response schemas with validation for order creation and updates.
"""

from pydantic import BaseModel, Field, field_validator
from typing import List, Optional
from datetime import datetime
from uuid import UUID


class OrderItemCreate(BaseModel):
    """Schema for creating an order item."""
    product_id: UUID
    product_name: str
    shop_name: str
    quantity: int = Field(..., gt=0, description="Quantity must be greater than 0")
    price: float = Field(..., gt=0, description="Price must be greater than 0")


class OrderItemResponse(BaseModel):
    """Schema for order item in response."""
    id: UUID
    product_id: UUID
    product_name: str
    shop_name: str
    quantity: int
    price: float

    class Config:
        from_attributes = True


class OrderCreate(BaseModel):
    """Schema for creating a new order."""
    customer_id: UUID
    total_price: float = Field(..., ge=0, description="Total price must be non-negative")
    delivery_cost: float = Field(..., ge=0, description="Delivery cost must be non-negative")
    grand_total: float = Field(..., ge=0, description="Grand total must be non-negative")
    items: List[OrderItemCreate] = Field(..., min_items=1, description="Order must have at least 1 item")

    @field_validator("grand_total")
    @classmethod
    def validate_grand_total(cls, v, info):
        """Validate that grand_total equals total_price + delivery_cost."""
        if "total_price" in info.data and "delivery_cost" in info.data:
            expected = info.data["total_price"] + info.data["delivery_cost"]
            # Allow small floating point differences
            if abs(v - expected) > 0.01:
                raise ValueError(
                    f"grand_total ({v}) must equal total_price ({info.data['total_price']}) + "
                    f"delivery_cost ({info.data['delivery_cost']})"
                )
        return v


class OrderResponse(BaseModel):
    """Schema for order in response."""
    id: UUID
    customer_id: UUID
    total_price: float
    delivery_cost: float
    grand_total: float
    status: str
    items: List[OrderItemResponse]
    created_at: datetime

    class Config:
        from_attributes = True


class OrderCreateResponse(BaseModel):
    """Schema for successful order creation response."""
    order_id: UUID
    status: str


class OrderStatusUpdate(BaseModel):
    """Schema for updating order status."""
    status: str = Field(..., description="New order status")

    @field_validator("status")
    @classmethod
    def validate_status(cls, v):
        """Validate that status is one of allowed values."""
        allowed_statuses = {"pending", "accepted", "picked_up", "delivered"}
        if v not in allowed_statuses:
            raise ValueError(
                f"Status must be one of {allowed_statuses}, got '{v}'"
            )
        return v
