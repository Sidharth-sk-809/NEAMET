from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from .. import crud, schemas
from ..database import get_db

router = APIRouter(prefix="/products", tags=["products"])


@router.get("/search", response_model=schemas.ProductSearchResponse)
def search_products(
    q: str = Query(..., min_length=1),
    range: int = Query(..., ge=1, le=10),
    db: Session = Depends(get_db),
):
    if range not in [2, 5, 10]:
        raise HTTPException(status_code=400, detail="range must be 2, 5, or 10")

    matches = crud.search_products(db, q, range)
    if not matches:
        raise HTTPException(status_code=404, detail="Product not found")

    products = [
        schemas.ProductSearchItem(
            product_name=item.name,
            price=item.price,
            shop_name=item.shop.name,
            shop_category=item.shop.category,
            distance=item.shop.distance_km,
        )
        for item in matches
    ]
    return schemas.ProductSearchResponse(range_km=range, products=products)
