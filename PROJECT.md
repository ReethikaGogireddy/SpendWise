# Frondend Flow

ReceiptPreviewScreen

        │
        ▼

ApiClient.uploadReceipt()

        │
        ▼

Backend JSON

        │
        ▼

jsonDecode()

        │
        ▼

Receipt.fromJson()

        │
        ├──────── receiptId
        │
        └──────── items
                    │
                    ▼
          ReceiptItem.fromJson()
                    │
                    ▼
          ReceiptItem Object
                    │
                    ▼
          List<ReceiptItem>

        │
        ▼

Receipt Object

        │
        ▼

ReceiptDetailsScreen
        │







# Backend Flow:
Flutter

↓

POST /receipts/upload

↓

routes.py

↓

ReceiptService.process_receipt()

↓

Save Image

↓

OCRService

↓

PaddleOCR

↓

Raw OCR Text

↓

ItemParser

↓

List<ReceiptItem>

↓

ReceiptRepository

↓

SQLite

↓

ReceiptResponse

↓

FastAPI

↓

JSON
