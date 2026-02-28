from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from .. import crud, models, schemas
from ..database import get_db
from .cart import _build_cart_response

router = APIRouter(tags=["orders"])


@router.post("/order/create", response_model=schemas.OrderCreateResponse)
def create_order(payload: schemas.OrderCreateRequest, db: Session = Depends(get_db)):
    customer = db.query(models.User).filter(models.User.id == payload.customer_id).first()
    if not customer or customer.role != "customer":
        raise HTTPException(status_code=400, detail="Invalid customer")

    cart = _build_cart_response(db, payload.customer_id)
    if not cart.items:
        raise HTTPException(status_code=400, detail="Cart is empty")

    total_cost = cart.total_product_price + cart.delivery_cost

    order = crud.create_order(
        db=db,
        customer_id=payload.customer_id,
        total_product_cost=cart.total_product_price,
        delivery_cost=cart.delivery_cost,
        total_cost=total_cost,
        total_distance=cart.total_travel_distance,
    )

    cart_items = crud.get_cart_items(db, payload.customer_id)
    crud.add_order_items(db, order.id, cart_items)
    crud.clear_cart(db, payload.customer_id)

    return schemas.OrderCreateResponse(
        order_id=order.id,
        status=order.status,
        total_product_cost=order.total_product_cost,
        delivery_cost=order.delivery_cost,
        total_cost=order.total_cost,
        total_distance=order.total_distance,
    )


@router.get("/orders/available", response_model=list[schemas.OrderSummary])
def available_orders(db: Session = Depends(get_db)):
    orders = crud.get_available_orders(db)
    return [
        schemas.OrderSummary(
            order_id=order.id,
            customer_id=order.customer_id,
            total_cost=order.total_cost,
            status=order.status,
        )
        for order in orders
    ]


@router.post("/orders/accept/{order_id}", response_model=schemas.OrderStatusResponse)
def accept_order(order_id: int, payload: schemas.OrderAcceptRequest, db: Session = Depends(get_db)):
    employee = db.query(models.User).filter(models.User.id == payload.employee_id).first()
    if not employee or employee.role != "employee":
        raise HTTPException(status_code=400, detail="Invalid employee")

    order = crud.get_order_by_id(db, order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    if order.status != "waiting_for_employee":
        raise HTTPException(status_code=400, detail="Order is not available for acceptance")

    updated = crud.accept_order(db, order_id, payload.employee_id)
    return schemas.OrderStatusResponse(
        order_id=updated.id,
        customer_id=updated.customer_id,
        employee_id=updated.employee_id,
        status=updated.status,
        total_product_cost=updated.total_product_cost,
        delivery_cost=updated.delivery_cost,
        total_cost=updated.total_cost,
        total_distance=updated.total_distance,
    )


@router.get("/order/status/{order_id}", response_model=schemas.OrderStatusResponse)
def order_status(order_id: int, db: Session = Depends(get_db)):
    order = crud.get_order_by_id(db, order_id)
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    return schemas.OrderStatusResponse(
        order_id=order.id,
        customer_id=order.customer_id,
        employee_id=order.employee_id,
        status=order.status,
        total_product_cost=order.total_product_cost,
        delivery_cost=order.delivery_cost,
        total_cost=order.total_cost,
        total_distance=order.total_distance,
    )
