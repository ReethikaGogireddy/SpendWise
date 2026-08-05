import os
import uuid

from fastapi import APIRouter, UploadFile, File, Depends
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.db import SessionLocal
from app.receipts.schemas import ReceiptRead
from app.receipts.service import save_receipt
from app.ai_service.ocr import extract_text
from app.ai_service.parser import parse_receipt_text

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


UPLOAD_DIR = "uploads"

@router.post("/upload")
async def upload_receipt(file: UploadFile = File(...)):
    os.makedirs(UPLOAD_DIR, exist_ok=True)

    ext = os.path.splitext(file.filename)[1]
    file_name = f"{uuid.uuid4()}{ext}"
    file_path = os.path.join(UPLOAD_DIR, file_name)

    with open(file_path, "wb") as buffer:
        buffer.write(await file.read())

    return {
        "message": "Receipt uploaded successfully",
        "filename": file_name,
        "file_path": file_path,
    }