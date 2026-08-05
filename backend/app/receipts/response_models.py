from pydantic import BaseModel


class ReceiptItemResponse(BaseModel):
    """
    Represents one parsed receipt item.

    Example:
        {
            "name": "BANANA CAVENDISH",
            "price": 1.32
        }
    """

    name: str
    price: float


class ReceiptResponse(BaseModel):
    """
    Represents the response returned to Flutter.

    Input:
        Parsed receipt items.

    Output:
        JSON response.
    """

    receipt_id: int

    items: list[ReceiptItemResponse]