from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app import schemas
from .. import crud
from ..database import get_db

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/login")
def login(payload: schemas.LoginRequest, db: Session = Depends(get_db)):
    user = crud.verify_user(db, payload.user_id, payload.password)
    if not user:
        raise HTTPException(status_code=401, detail="Wrong login credentials")

    return {"id": user.id, "name": user.name, "role": user.role}
