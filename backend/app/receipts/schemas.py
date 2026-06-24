from pydantic import BaseModel, ConfigDict
from typing import Optional




class ReceiptBase(BaseModel):
    merchant_name: Optional[str] = None
    receipt_date: Optional[str] = None
    total_amount: Optional[float] = None
    raw_text: Optional[str] = None

# The schema that is used to create the receipt
class ReceiptCreate(ReceiptBase):
    pass

# Response schema returned by the API
class ReceiptRead(ReceiptBase):
    id: int
    image_path: str

    model_config = ConfigDict(
        from_attributes=True
    )