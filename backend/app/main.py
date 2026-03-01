from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi import Request

from .database import Base, engine
# Import all models to register them with Base
from .models import Order
from .routers.auth import router as auth_router
from .routers.cart import router as cart_router
from .routers.orders import router as orders_router
from .routers.products import router as products_router

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


app.include_router(auth_router)
app.include_router(products_router)
app.include_router(cart_router)
app.include_router(orders_router)


@app.get("/")
def health_check():
    return {"message": "NEAMET backend is running"}