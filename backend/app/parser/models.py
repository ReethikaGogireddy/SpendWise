from dataclasses import dataclass


@dataclass
class ReceiptItem:
    """
    Represents one item on the receipt.

    Example:
        BANANA CAVENDISH
        $1.32
    """

    name: str
    price: float