from paddleocr import PaddleOCR


class PaddleOCREngine:
    """
    Responsibility:
        Communicates with PaddleOCR.

    Input:
        image_path (str)

    Output:
        Raw text extracted from the receipt.
    """

    def __init__(self):
        """
        Creates one PaddleOCR instance.

        This is done once when the application starts,
        instead of creating a new OCR model for every request.
        """

        self.ocr = PaddleOCR(
            use_angle_cls=True,
            lang="en",
        )

    def extract(self, image_path: str) -> str:
        """
        Input:
            Image path.

        Output:
            One string containing all OCR text.
        """

        # result = self.ocr.ocr(image_path)

        # extracted_text = []

        # # Iterate through every detected text block.
        # for page in result:
        #     for line in page:
        #         extracted_text.append(line[1][0])

        result = self.ocr.ocr(image_path)

    # Get the first page/result
        page = result[0]

        # Extract only the recognized text
        extracted_text = "\n".join(page["rec_texts"])

        return extracted_text

        