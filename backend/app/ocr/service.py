from app.ocr.paddle_ocr import PaddleOCREngine


class OCRService:
    """
    Responsibility:
        Provides OCR functionality to the rest
        of the application.

    Input:
        Image path.

    Output:
        Raw OCR text.
    """

    def __init__(self):

        self.engine = PaddleOCREngine()

    def extract_text(self, image_path: str):
        """
        Calls the OCR engine.

        Input:
            image_path

        Output:
            raw_text
        """

        return self.engine.extract(image_path)