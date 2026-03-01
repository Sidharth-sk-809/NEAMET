from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from .. import crud, schemas
from ..database import get_db

router = APIRouter(prefix="/products", tags=["products"])


# ===============================
# ✅ GET ALL PRODUCTS (HOME PAGE)
# ===============================
@router.get("", response_model=list[schemas.ProductSearchItem])
def get_products(
    range: int = Query(2, ge=1, le=10),
    db: Session = Depends(get_db),
):
    """
    Fetch all products within selected distance range
    Used in HOME SCREEN
    """

    if range not in [2, 5, 10]:
        raise HTTPException(
            status_code=400,
            detail="range must be 2, 5, or 10",
        )

    products = crud.get_products_by_range(db, range)

    return [
        schemas.ProductSearchItem(
            product_name=item.name,
            price=item.price,
            shop_name=item.shop.name,
            shop_category=item.shop.category,
            distance=item.shop.distance_km,
        )
        for item in products
    ]


# ===============================
# ✅ SEARCH PRODUCTS
# ===============================
@router.get("/search", response_model=schemas.ProductSearchResponse)
def search_products(
    q: str = Query(..., min_length=1),
    range: int = Query(2, ge=1, le=10),
    db: Session = Depends(get_db),
):

    if range not in [2, 5, 10]:
        raise HTTPException(
            status_code=400,
            detail="range must be 2, 5, or 10",
        )

    matches = crud.search_products(db, q, range)

    return schemas.ProductSearchResponse(
        range_km=range,
        products=[
            schemas.ProductSearchItem(
                product_name=item.name,
                price=item.price,
                shop_name=item.shop.name,
                shop_category=item.shop.category,
                distance=item.shop.distance_km,
            )
            for item in matches
        ],
    )