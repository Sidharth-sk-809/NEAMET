from sqlalchemy.orm import Session
from sqlalchemy import func

from . import models


def verify_user(db: Session, user_id: str, password: str):
    return (
        db.query(models.User)
        .filter(models.User.id == user_id, models.User.password == password)
        .first()
    )


def search_products(db: Session, query: str, max_range: int):
    return (
        db.query(models.Product)
        .join(models.Shop)
        .filter(func.lower(models.Product.name).contains(query.lower()))
        .filter(models.Shop.distance_km <= max_range)
        .order_by(models.Shop.distance_km.asc(), models.Product.name.asc())
        .all()
    )


def add_to_cart(db: Session, customer_id: str, product_id: int, quantity: int):
    existing_item = (
        db.query(models.CartItem)
        .filter(
            models.CartItem.customer_id == customer_id,
            models.CartItem.product_id == product_id,
        )
        .first()
    )
    if existing_item:
        existing_item.quantity += quantity
        db.commit()
        db.refresh(existing_item)
        return existing_item

    new_item = models.CartItem(
        customer_id=customer_id,
        product_id=product_id,
        quantity=quantity,
    )
    db.add(new_item)
    db.commit()
    db.refresh(new_item)
    return new_item


def get_cart_items(db: Session, customer_id: str):
    return (
        db.query(models.CartItem)
        .filter(models.CartItem.customer_id == customer_id)
        .all()
    )


def clear_cart(db: Session, customer_id: str):
    db.query(models.CartItem).filter(models.CartItem.customer_id == customer_id).delete()
    db.commit()


def create_order(
    db: Session,
    customer_id: str,
    total_product_cost: float,
    delivery_cost: float,
    total_cost: float,
    total_distance: float,
):
    order = models.Order(
        customer_id=customer_id,
        employee_id=None,
        total_product_cost=total_product_cost,
        delivery_cost=delivery_cost,
        total_cost=total_cost,
        total_distance=total_distance,
        status="waiting_for_employee",
    )
    db.add(order)
    db.commit()
    db.refresh(order)
    return order


def add_order_items(db: Session, order_id: int, cart_items):
    for item in cart_items:
        db.add(
            models.OrderItem(
                order_id=order_id,
                product_id=item.product_id,
                quantity=item.quantity,
            )
        )
    db.commit()


def get_available_orders(db: Session):
    return (
        db.query(models.Order)
        .filter(models.Order.status == "waiting_for_employee")
        .order_by(models.Order.id.asc())
        .all()
    )


def accept_order(db: Session, order_id: int, employee_id: str):
    order = db.query(models.Order).filter(models.Order.id == order_id).first()
    if not order:
        return None
    if order.status != "waiting_for_employee":
        return order

    order.employee_id = employee_id
    order.status = "out_for_delivery"
    db.commit()
    db.refresh(order)
    return order


def get_order_by_id(db: Session, order_id: int):
    return db.query(models.Order).filter(models.Order.id == order_id).first()
