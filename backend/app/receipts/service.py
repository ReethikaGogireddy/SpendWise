import os
import uuid
from sqlalchemy.orm import Session
from app.receipts.models import Receipt
from app.core.config import settings
from app.ocr.service import OCRService
from app.receipts.repository import ReceiptRepository


class ReceiptService:
    """
    Responsibility:

    Coordinates the complete receipt pipeline.

    Upload
        ↓
    Save Image
        ↓
    OCR
        ↓
    Save Receipt
        ↓
    Return Receipt
    """

    def __init__(self, db):

        self.repository = ReceiptRepository(db)
        self.ocr = OCRService()

    def process_receipt(self, upload_file):
        """
        Input:
            UploadFile from FastAPI.

        Output:
            Saved Receipt object.
        """

        # -----------------------
        # Step 1
        # Save uploaded image.
        # -----------------------

        os.makedirs(
            settings.upload_dir,
            exist_ok=True,
        )

        extension = os.path.splitext(
            upload_file.filename
        )[1]

        file_name = f"{uuid.uuid4()}{extension}"

        image_path = os.path.join(
            settings.upload_dir,
            file_name,
        )

        with open(image_path, "wb") as buffer:

            buffer.write(
                upload_file.file.read()
            )

        # -----------------------
        # Step 2
        # Extract OCR text.
        # -----------------------

        raw_text = self.ocr.extract_text(
            image_path
        )

        # -----------------------
        # Step 3
        # Save into database.
        # -----------------------

        receipt = self.repository.save(
            image_path=image_path,
            raw_text=raw_text,
        )

        # -----------------------
        # Step 4
        # Return saved receipt.
        # -----------------------

        return receipt