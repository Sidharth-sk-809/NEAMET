from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi import Request

from .database import Base, engine
# Import all models to register them with Base
from .models import Order, OrderItem
from .routers import auth, cart, orders, products

app = FastAPI(title="NEAMET Prototype Backend")

# ✅ CREATE TABLES AUTOMATICALLY
@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.exception_handler(Exception)
async def generic_exception_handler(_: Request, __: Exception):
    return JSONResponse(status_code=500, content={"detail": "Server issue"})


app.include_router(auth.router)
app.include_router(products.router)
app.include_router(cart.router)
app.include_router(orders.router)


@app.get("/")
def health_check():
    return {"message": "NEAMET backend is running"}