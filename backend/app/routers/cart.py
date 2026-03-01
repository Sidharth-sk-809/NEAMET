from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from .. import crud, models, schemas
from ..database import get_db

router = APIRouter(prefix="/cart", tags=["cart"])


@router.post("/add", response_model=schemas.CartResponse)
def add_to_cart(payload: schemas.CartAddRequest, db: Session = Depends(get_db)):
    customer = db.query(models.User).filter(models.User.id == payload.customer_id).first()
    if not customer or customer.role != "customer":
        raise HTTPException(status_code=400, detail="Invalid customer")

    product = db.query(models.Product).filter(models.Product.id == payload.product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    crud.add_to_cart(db, payload.customer_id, payload.product_id, payload.quantity)
    return _build_cart_response(db, payload.customer_id)


@router.get("/{customer_id}", response_model=schemas.CartResponse)
def get_cart(customer_id: str, db: Session = Depends(get_db)):
    customer = db.query(models.User).filter(models.User.id == customer_id).first()
    if not customer or customer.role != "customer":
        raise HTTPException(status_code=400, detail="Invalid customer")

    return _build_cart_response(db, customer_id)


def _build_cart_response(db: Session, customer_id: str):
    items = crud.get_cart_items(db, customer_id)
    cart_view = []
    unique_shop_distances = {}
    total_product_price = 0.0

    for item in items:
        product = item.product
        if not product:
            continue
        shop = product.shop
        line_total = product.price * item.quantity
        total_product_price += line_total
        unique_shop_distances[shop.id] = shop.distance_km

        cart_view.append(
            schemas.CartItemView(
                product_id=product.id,
                product_name=product.name,
                shop_name=shop.name,
                quantity=item.quantity,
                unit_price=product.price,
                line_total=line_total,
            )
        )

    total_distance = max(unique_shop_distances.values()) if unique_shop_distances else 0
    delivery_cost = total_distance * 10

    return schemas.CartResponse(
        customer_id=customer_id,
        items=cart_view,
        total_product_price=total_product_price,
        unique_shops_involved=len(unique_shop_distances),
        total_travel_distance=total_distance,
        delivery_cost=delivery_cost,
    )
