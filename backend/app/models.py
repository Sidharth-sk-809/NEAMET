from sqlalchemy import Column, Float, ForeignKey, Integer, String, UniqueConstraint
from sqlalchemy.orm import relationship

from .database import Base


# ========================
# USER
# ========================
class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True)
    name = Column(String, nullable=False)
    password = Column(String, nullable=False)
    role = Column(String, nullable=False)

    # Relationships
    cart_items = relationship("CartItem", back_populates="customer", cascade="all, delete-orphan")
    orders = relationship("Order", foreign_keys="Order.customer_id", back_populates="customer")
    assigned_orders = relationship("Order", foreign_keys="Order.employee_id", back_populates="employee")


# ========================
# SHOP
# ========================
class Shop(Base):
    __tablename__ = "shops"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False, unique=True)
    category = Column(String, nullable=False)
    distance_km = Column(Integer, nullable=False)

    products = relationship("Product", back_populates="shop", cascade="all, delete-orphan")


# ========================
# PRODUCT
# ========================
class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    shop_id = Column(Integer, ForeignKey("shops.id"), nullable=False)
    price = Column(Float, nullable=False)

    shop = relationship("Shop", back_populates="products")
    cart_items = relationship("CartItem", back_populates="product")
    order_items = relationship("OrderItem", back_populates="product")


# ========================
# CART ITEM
# ========================
class CartItem(Base):
    __tablename__ = "cart_items"

    id = Column(Integer, primary_key=True, index=True)
    customer_id = Column(String, ForeignKey("users.id"), nullable=False)
    product_id = Column(Integer, ForeignKey("products.id"), nullable=False)
    quantity = Column(Integer, nullable=False, default=1)

    customer = relationship("User", back_populates="cart_items")
    product = relationship("Product", back_populates="cart_items")

    __table_args__ = (
        UniqueConstraint("customer_id", "product_id", name="uq_customer_product"),
    )


# ========================
# ORDER
# ========================
class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True, index=True)
    customer_id = Column(String, ForeignKey("users.id"), nullable=False)
    employee_id = Column(String, ForeignKey("users.id"), nullable=True)

    total_product_cost = Column(Float, nullable=False)
    delivery_cost = Column(Float, nullable=False)
    total_cost = Column(Float, nullable=False)
    total_distance = Column(Float, nullable=False)
    status = Column(String, nullable=False)

    customer = relationship("User", foreign_keys=[customer_id], back_populates="orders")
    employee = relationship("User", foreign_keys=[employee_id], back_populates="assigned_orders")
    items = relationship("OrderItem", back_populates="order", cascade="all, delete-orphan")


# ========================
# ORDER ITEM
# ========================
class OrderItem(Base):
    __tablename__ = "order_items"

    order_id = Column(Integer, ForeignKey("orders.id"), primary_key=True)
    product_id = Column(Integer, ForeignKey("products.id"), primary_key=True)
    quantity = Column(Integer, nullable=False)

    order = relationship("Order", back_populates="items")
    product = relationship("Product", back_populates="order_items")