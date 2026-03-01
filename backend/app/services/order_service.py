"""
Order service layer with business logic.

Handles order creation, retrieval, and status updates with proper validation.
"""

from sqlalchemy.orm import Session
from sqlalchemy import select
from uuid import UUID
from typing import List, Optional

from app.models.order import Order, OrderItem
from app.schemas.order import OrderCreate, OrderStatusUpdate


class OrderService:
    """Service class for order management operations."""

    @staticmethod
    def create_order(db: Session, order_data: OrderCreate) -> Order:
        """
        Create a new order with items.
        
        Args:
            db: Database session
            order_data: Order creation request data
            
        Returns:
            Created Order object
            
        Raises:
            ValueError: If validation fails
        """
        # Create order record
        order = Order(
            customer_id=order_data.customer_id,
            total_price=order_data.total_price,
            delivery_cost=order_data.delivery_cost,
            grand_total=order_data.grand_total,
            status="pending"
        )

        # Add order to session to generate ID
        db.add(order)
        db.flush()  # Flush to get the order ID

        # Create order items
        for item_data in order_data.items:
            order_item = OrderItem(
                order_id=order.id,
                product_id=item_data.product_id,
                product_name=item_data.product_name,
                shop_name=item_data.shop_name,
                quantity=item_data.quantity,
                price=item_data.price
            )
            db.add(order_item)

        # Commit transaction
        db.commit()
        db.refresh(order)

        return order

    @staticmethod
    def get_orders(
        db: Session,
        status: Optional[str] = None,
        limit: int = 100,
        offset: int = 0
    ) -> List[Order]:
        """
        Retrieve orders with optional status filter.
        
        Args:
            db: Database session
            status: Optional status filter
            limit: Maximum number of results
            offset: Number of results to skip
            
        Returns:
            List of Order objects
        """
        query = db.query(Order)

        if status:
            query = query.filter(Order.status == status)

        return query.offset(offset).limit(limit).all()

    @staticmethod
    def get_order_by_id(db: Session, order_id: UUID) -> Optional[Order]:
        """
        Retrieve a specific order by ID.
        
        Args:
            db: Database session
            order_id: Order UUID
            
        Returns:
            Order object or None if not found
        """
        return db.query(Order).filter(Order.id == order_id).first()

    @staticmethod
    def update_order_status(
        db: Session,
        order_id: UUID,
        status_update: OrderStatusUpdate
    ) -> Optional[Order]:
        """
        Update order status.
        
        Args:
            db: Database session
            order_id: Order UUID
            status_update: New status data
            
        Returns:
            Updated Order object or None if not found
        """
        order = db.query(Order).filter(Order.id == order_id).first()

        if not order:
            return None

        order.status = status_update.status
        db.commit()
        db.refresh(order)

        return order
