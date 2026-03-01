"""
Order routes for FastAPI.

Endpoints for creating, retrieving, and updating orders.
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from uuid import UUID
from typing import List

from app.database import get_db
from app.schemas.order import (
    OrderCreate,
    OrderCreateResponse,
    OrderResponse,
    OrderStatusUpdate
)
from app.services.order_service import OrderService

router = APIRouter(prefix="/orders", tags=["orders"])


@router.post(
    "",
    response_model=OrderCreateResponse,
    status_code=201,
    summary="Create a new order"
)
def create_order(
    order_data: OrderCreate,
    db: Session = Depends(get_db)
) -> OrderCreateResponse:
    """
    Create a new order with items.
    
    **Request body:**
    - customer_id: UUID of the customer
    - total_price: Sum of item prices
    - delivery_cost: Delivery cost
    - grand_total: total_price + delivery_cost
    - items: List of items to order
    
    **Returns:**
    - order_id: UUID of created order
    - status: Initial status (pending)
    
    **Status codes:**
    - 201: Order created successfully
    - 400: Validation error (invalid data)
    """
    try:
        order = OrderService.create_order(db, order_data)
        return OrderCreateResponse(order_id=order.id, status=order.status)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get(
    "",
    response_model=List[OrderResponse],
    summary="Get orders with optional status filter"
)
def get_orders(
    status: str = Query(None, description="Filter by status (pending, accepted, picked_up, delivered)"),
    limit: int = Query(100, ge=1, le=1000),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db)
) -> List[OrderResponse]:
    """
    Retrieve orders with optional status filter.
    
    **Query parameters:**
    - status: Optional filter by order status
    - limit: Maximum number of results (default: 100, max: 1000)
    - offset: Number of results to skip (default: 0)
    
    **Returns:**
    List of orders matching the criteria.
    
    **Status codes:**
    - 200: Success
    """
    return OrderService.get_orders(db, status=status, limit=limit, offset=offset)


@router.get(
    "/{order_id}",
    response_model=OrderResponse,
    summary="Get a specific order"
)
def get_order(
    order_id: UUID,
    db: Session = Depends(get_db)
) -> OrderResponse:
    """
    Retrieve a specific order by ID.
    
    **Path parameters:**
    - order_id: UUID of the order
    
    **Returns:**
    Order details including items.
    
    **Status codes:**
    - 200: Order found
    - 404: Order not found
    """
    order = OrderService.get_order_by_id(db, order_id)

    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    return order


@router.patch(
    "/{order_id}/status",
    response_model=OrderResponse,
    summary="Update order status"
)
def update_order_status(
    order_id: UUID,
    status_update: OrderStatusUpdate,
    db: Session = Depends(get_db)
) -> OrderResponse:
    """
    Update the status of an order.
    
    **Path parameters:**
    - order_id: UUID of the order
    
    **Request body:**
    - status: New status (pending, accepted, picked_up, delivered)
    
    **Returns:**
    Updated order details.
    
    **Status codes:**
    - 200: Status updated successfully
    - 400: Invalid status value
    - 404: Order not found
    """
    order = OrderService.update_order_status(db, order_id, status_update)

    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    return order
