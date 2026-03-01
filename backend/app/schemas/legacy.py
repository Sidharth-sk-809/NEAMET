"""Legacy schemas for auth, products, and cart."""

from typing import List, Optional
from pydantic import BaseModel, Field


class LoginRequest(BaseModel):
    user_id: str = Field(..., alias="id")
    password: str


class LoginResponse(BaseModel):
    id: str
    name: str
    role: str


class ProductSearchItem(BaseModel):
    product_name: str
    price: float
    shop_name: str
    shop_category: str
    distance: int


class ProductSearchResponse(BaseModel):
    range_km: int
    products: List[ProductSearchItem]


class CartAddRequest(BaseModel):
    customer_id: str
    product_id: int
    quantity: int = Field(..., gt=0)


class CartItemView(BaseModel):
    product_id: int
    product_name: str
    shop_name: str
    quantity: int
    unit_price: float
    line_total: float


class CartResponse(BaseModel):
    customer_id: str
    items: List[CartItemView]
    total_product_price: float
    unique_shops_involved: int
    total_travel_distance: int
    delivery_cost: float


class OrderCreateRequest(BaseModel):
    customer_id: str


class OrderCreateResponse(BaseModel):
    order_id: int
    status: str
    total_product_cost: float
    delivery_cost: float
    total_cost: float
    total_distance: float


class OrderSummary(BaseModel):
    order_id: int
    customer_id: str
    total_cost: float
    status: str


class OrderAcceptRequest(BaseModel):
    employee_id: str


class OrderStatusResponse(BaseModel):
    order_id: int
    customer_id: str
    employee_id: Optional[str]
    status: str
    total_product_cost: float
    delivery_cost: float
    total_cost: float
    total_distance: float
