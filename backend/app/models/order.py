"""
SQLAlchemy models for Order Management.

Includes Order and OrderItem models with proper relationships,
UUID primary keys, and cascade delete support.
"""

from sqlalchemy import Column, String, Float, DateTime, ForeignKey, Integer
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid

from .database import Base


class Order(Base):
    """
    Order model representing a customer's order.
    
    Attributes:
        id: Unique identifier (UUID)
        customer_id: Reference to customer (UUID)
        total_price: Sum of all item prices
        delivery_cost: Calculated delivery cost
        grand_total: total_price + delivery_cost
        status: Order status (pending, accepted, picked_up, delivered)
        items: Relationship to OrderItem objects
        created_at: Timestamp of order creation
    """
    __tablename__ = "orders"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    customer_id = Column(UUID(as_uuid=True), nullable=False, index=True)
    total_price = Column(Float, nullable=False)
    delivery_cost = Column(Float, nullable=False)
    grand_total = Column(Float, nullable=False)
    status = Column(String, default="pending", index=True)
    created_at = Column(DateTime, default=datetime.utcnow, index=True)

    # Relationship with cascade delete
    items = relationship(
        "OrderItem",
        back_populates="order",
        cascade="all, delete-orphan",
        lazy="joined"
    )

    def __repr__(self):
        return f"<Order(id={self.id}, customer_id={self.customer_id}, status={self.status})>"


class OrderItem(Base):
    """
    OrderItem model representing a single item in an order.
    
    Attributes:
        id: Unique identifier (UUID)
        order_id: Foreign key to Order
        product_id: Reference to product (UUID)
        product_name: Name of the product
        shop_name: Name of the shop
        quantity: Number of items
        price: Price per item
        order: Relationship back to Order
    """
    __tablename__ = "order_items"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    order_id = Column(
        UUID(as_uuid=True),
        ForeignKey("orders.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    product_id = Column(UUID(as_uuid=True), nullable=False, index=True)
    product_name = Column(String, nullable=False)
    shop_name = Column(String, nullable=False)
    quantity = Column(Integer, nullable=False)
    price = Column(Float, nullable=False)

    # Relationship back to Order
    order = relationship("Order", back_populates="items")

    def __repr__(self):
        return f"<OrderItem(id={self.id}, product_name={self.product_name}, qty={self.quantity})>"
