import os
from sqlalchemy.orm import Session

from app.receipts.models import Receipt


def save_receipt(
    db: Session,
    image_path: str,
    merchant_name: str | None = None,
    receipt_date: str | None = None,
    total_amount: float | None = None,
    raw_text: str | None = None,
):
    receipt = Receipt(
        image_path=image_path,
        merchant_name=merchant_name,
        receipt_date=receipt_date,
        total_amount=total_amount,
        raw_text=raw_text,
    )
    db.add(receipt)
    db.commit()
    db.refresh(receipt)
    return receipt