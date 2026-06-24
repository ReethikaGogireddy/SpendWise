from sqlalchemy import Column, Integer, String, Float, DateTime, Text
from sqlalchemy.sql import func

from app.core.db import Base


class Receipt(Base):
    __tablename__ = "receipts"

    id = Column(Integer, primary_key=True, index=True)
    merchant_name = Column(String(255), nullable=True)
    receipt_date = Column(String(50), nullable=True)
    total_amount = Column(Float, nullable=True)
    image_path = Column(String(500), nullable=False)
    raw_text = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())