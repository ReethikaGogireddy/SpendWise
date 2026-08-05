import os
import uuid

from fastapi import APIRouter, UploadFile, File, Depends
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.db import SessionLocal
from app.receipts.service import ReceiptService

router = APIRouter(prefix="/receipts", tags=["Receipts"])


def get_db():
    """
    Creates one database session
    for every request.
    """

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()



@router.post("/upload")
async def upload_receipt(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
):
    """
    Input:
        Uploaded receipt image.

    Output:
        Parsed receipt JSON.
    """

    service = ReceiptService(db)

    return service.process_receipt(file)