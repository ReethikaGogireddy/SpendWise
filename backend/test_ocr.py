from app.ocr.service import OCRService

ocr = OCRService()

text = ocr.extract_text("uploads/test_receipt.jpg")

print(text)