from app.ocr.service import OCRService
from app.parser.item_parser import ItemParser

ocr = OCRService()

raw_text = ocr.extract_text("uploads/test_receipt.jpg")

parser = ItemParser()

items = parser.parse(raw_text)

print("\nItems Found:\n")

for item in items:
    print(item)