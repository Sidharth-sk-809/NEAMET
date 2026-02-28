from sqlalchemy.orm import Session

from .database import Base, SessionLocal, engine
from .models import Product, Shop, User


def seed_users(db: Session):
    users = [
        {"id": "customer_1", "name": "Primary Customer", "password": "12345", "role": "customer"},
        {"id": "emp_001", "name": "Delivery Employee", "password": "23456", "role": "employee"},
    ]

    for user_data in users:
        existing = db.query(User).filter(User.id == user_data["id"]).first()
        if existing:
            existing.name = user_data["name"]
            existing.password = user_data["password"]
            existing.role = user_data["role"]
        else:
            db.add(User(**user_data))


def seed_shops_and_products(db: Session):
    seed_catalog = [
        {
            "name": "City Grocery Hub",
            "category": "Grocery Store",
            "distance_km": 2,
            "products": [
                ("Rice", 62),
                ("Wheat Flour", 48),
                ("Sugar", 42),
                ("Cooking Oil", 155),
                ("Salt", 22),
                ("Tea Powder", 88),
            ],
        },
        {
            "name": "Fresh Vegetable Point",
            "category": "Vegetable Shop",
            "distance_km": 5,
            "products": [
                ("Potato", 30),
                ("Tomato", 35),
                ("Onion", 32),
                ("Carrot", 45),
                ("Cabbage", 40),
                ("Green Chilli", 25),
            ],
        },
        {
            "name": "Care Medical Store",
            "category": "Medical Store",
            "distance_km": 2,
            "products": [
                ("Paracetamol", 25),
                ("Ibuprofen", 30),
                ("Bandage", 20),
                ("Antiseptic Cream", 65),
                ("Vitamin Tablets", 120),
                ("Cough Syrup", 95),
            ],
        },
        {
            "name": "WriteRight Stationery",
            "category": "Stationery Shop",
            "distance_km": 5,
            "products": [
                ("Pen", 12),
                ("Pencil", 8),
                ("Notebook", 40),
                ("Eraser", 6),
                ("Marker", 28),
                ("Scale", 15),
            ],
        },
        {
            "name": "Daily Bake Corner",
            "category": "Bakery",
            "distance_km": 2,
            "products": [
                ("Bread", 35),
                ("Bun", 20),
                ("Cake Slice", 45),
                ("Biscuit Pack", 30),
                ("Donut", 25),
                ("Puff", 30),
            ],
        },
        {
            "name": "StepIn Footwear",
            "category": "Footwear Store",
            "distance_km": 10,
            "products": [
                ("Running Shoes", 2200),
                ("Sandals", 750),
                ("Formal Shoes", 1800),
                ("Slippers", 300),
                ("Sports Shoes", 2500),
                ("Kids Shoes", 1200),
            ],
        },
        {
            "name": "BuildPro Hardware",
            "category": "Hardware Store",
            "distance_km": 10,
            "products": [
                ("PVC Pipe", 280),
                ("Hammer", 350),
                ("Screwdriver", 180),
                ("Nails Pack", 90),
                ("Water Tap", 420),
                ("Wrench", 260),
            ],
        },
    ]

    for shop_data in seed_catalog:
        shop = db.query(Shop).filter(Shop.name == shop_data["name"]).first()
        if not shop:
            shop = Shop(
                name=shop_data["name"],
                category=shop_data["category"],
                distance_km=shop_data["distance_km"],
            )
            db.add(shop)
            db.flush()
        else:
            shop.category = shop_data["category"]
            shop.distance_km = shop_data["distance_km"]

        for product_name, price in shop_data["products"]:
            product = (
                db.query(Product)
                .filter(Product.name == product_name, Product.shop_id == shop.id)
                .first()
            )
            if product:
                product.price = float(price)
            else:
                db.add(Product(name=product_name, shop_id=shop.id, price=float(price)))


# Safe re-run behavior:
# - Existing records are updated
# - Missing records are inserted
# - No duplicate shop/product rows are created

def run_seed():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        seed_users(db)
        seed_shops_and_products(db)
        db.commit()
        print("Seed complete: users, shops, and products are ready.")
    except Exception:
        db.rollback()
        raise
    finally:
        db.close()


if __name__ == "__main__":
    run_seed()
