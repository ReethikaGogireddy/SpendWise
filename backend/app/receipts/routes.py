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
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/upload", response_model=ReceiptRead)
async def upload_receipt(file: UploadFile = File(...), db: Session = Depends(get_db)):
    os.makedirs(settings.upload_dir, exist_ok=True)

    file_ext = os.path.splitext(file.filename)[1]
    file_name = f"{uuid.uuid4()}{file_ext}"
    file_path = os.path.join(settings.upload_dir, file_name)

    with open(file_path, "wb") as buffer:
        buffer.write(await file.read())

    raw_text = extract_text(file_path)
    parsed = parse_receipt_text(raw_text)

    receipt = save_receipt(
        db=db,
        image_path=file_path,
        merchant_name=parsed.get("merchant_name"),
        receipt_date=parsed.get("receipt_date"),
        total_amount=parsed.get("total_amount"),
        raw_text=raw_text,
    )

    return receipt