from sqlalchemy.orm import Session

from app.receipts.models import Receipt


class ReceiptRepository:
    """
    Responsibility:
        Saves and retrieves receipts
        from the database.
    """

    def __init__(self, db: Session):

        self.db = db

    def save(
        self,
        image_path: str,
        raw_text: str,
    ):
        """
        Input:
            image_path
            raw_text

        Output:
            Saved Receipt object.
        """

        receipt = Receipt(
            image_path=image_path,
            raw_text=raw_text,
        )

        self.db.add(receipt)
        self.db.commit()
        self.db.refresh(receipt)

        return receipt