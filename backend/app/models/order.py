from sqlalchemy import Column, String, Float, Integer
from sqlalchemy.orm import relationship

from app.database import Base


class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True, index=True)
    customer_id = Column(String, nullable=False, index=True)
    employee_id = Column(String, nullable=True, index=True)

    total_product_cost = Column(Float, nullable=False)
    delivery_cost = Column(Float, nullable=False)
    total_cost = Column(Float, nullable=False)
    total_distance = Column(Float, nullable=False)

    status = Column(String, nullable=False, index=True)