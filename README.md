# SpendWise

SpendWise is a full-stack receipt-based expense tracking application that converts receipt images into structured purchase data. The current MVP supports receipt capture/upload from a Flutter client, OCR processing with PaddleOCR, rule-based item extraction, persistence through a FastAPI backend, and a mobile receipt-details view.

> **Current status:** MVP in active development. Receipt upload, OCR, item parsing, backend/frontend integration, and receipt-item display are working. Budgeting, categorization, analytics, authentication, and AI-driven insights are planned but are not implemented yet.

## What Works Today

- Capture a receipt using the mobile camera or select an image.
- Preview the receipt before uploading it.
- Upload the image from Flutter to the FastAPI backend using a multipart HTTP request.
- Save the uploaded receipt image on the backend.
- Extract receipt text locally using PaddleOCR.
- Parse item names and prices from OCR output.
- Ignore selected non-item lines such as weight/quantity annotations containing `NET` or `@`.
- Stop item parsing when totals/payment sections begin.
- Save receipt metadata and raw OCR text to the database.
- Return structured receipt data as JSON from FastAPI.
- Convert backend JSON into strongly typed Dart `Receipt` and `ReceiptItem` models.
- Display parsed items and prices in a scrollable Flutter receipt-details screen.
- Display simple item-specific emoji/icons in the receipt UI.



## Tech Stack

### Frontend

- Flutter
- Dart
- Material UI
- `http` for REST/multipart requests
- `image_picker` for camera/gallery image selection

### Backend

- Python
- FastAPI
- SQLAlchemy
- SQLite
- Pydantic

### OCR and Parsing

- PaddleOCR / PaddleX
- Rule-based Python receipt item parser
- Regular expressions for price detection

## Project Structure

The exact project may evolve, but the current architecture follows this organization:

```text
SpendWise/
|
|-- backend/
|   |-- app/
|   |   |-- core/
|   |   |   |-- config.py
|   |   |   `-- db.py
|   |   |
|   |   |-- ocr/
|   |   |   |-- paddle_ocr.py
|   |   |   `-- service.py
|   |   |
|   |   |-- parser/
|   |   |   |-- models.py
|   |   |   `-- item_parser.py
|   |   |
|   |   |-- receipts/
|   |   |   |-- models.py
|   |   |   |-- repository.py
|   |   |   |-- response_models.py
|   |   |   |-- routes.py
|   |   |   `-- service.py
|   |   |
|   |   `-- main.py
|   |
|   `-- uploads/
|
|-- spendwise_frontend/
|   `-- lib/
|       |-- core/
|       |   |-- api/
|       |   |   `-- api_client.dart
|       |   `-- utils/
|       |       `-- item_icons.dart
|       |
|       `-- features/
|           `-- receipts/
|               |-- models/
|               |   |-- receipt.dart
|               |   `-- receipt_item.dart
|               |-- screens/
|               |   |-- receipt_preview_screen.dart
|               |   `-- receipt_details_screen.dart
|               `-- services/
|                   `-- receipt_service.dart
|
`-- README.md
```

## Backend Architecture

The backend separates responsibilities rather than putting the complete workflow inside the API route.

### `routes.py`

Receives the HTTP request and passes the uploaded file and database session to `ReceiptService`.

**Input:** FastAPI `UploadFile`  
**Output:** structured receipt response

### `ReceiptService`

Coordinates the receipt-processing workflow.

```text
UploadFile -> Save Image -> OCR -> Parse Items -> Save Receipt -> Build Response
```

### `OCRService`

Provides OCR functionality to the rest of the backend without requiring other modules to depend directly on PaddleOCR.

**Input:** image path  
**Output:** raw OCR text

### `PaddleOCREngine`

Calls PaddleOCR and extracts recognized text from the current PaddleOCR/PaddleX response format (`rec_texts`).

### `ItemParser`

Converts raw OCR text into a list of structured receipt items.

**Input:** raw OCR text  
**Output:** `list[ReceiptItem]`

Current parsing rules include:

- Recognize prices such as `$4.66` or `4.66`.
- Pair item names with prices.
- Ignore lines containing `NET` or `@` for the current receipt format.
- Stop parsing when keywords such as `TOTAL`, `SUBTOTAL`, `LOYALTY`, `CASH`, `CHANGE`, or `TAX` are reached.

### `ReceiptRepository`

Handles persistence so database operations remain separate from OCR and parsing logic.

## Example API Response

`POST /receipts/upload` currently returns data similar to:

```json
{
  "receipt_id": 1,
  "items": [
    {
      "name": "ZUCHINNI GREEN",
      "price": 4.66
    },
    {
      "name": "BANANA CAVENDISH",
      "price": 1.32
    },
    {
      "name": "BROCCOLI",
      "price": 4.84
    }
  ]
}
```

## Frontend Data Flow

The Flutter UI does not work directly with raw JSON after the API layer.

```text
Backend JSON
     |
     v
jsonDecode()
     |
     v
Map<String, dynamic>
     |
     v
Receipt.fromJson()
     |
     +--> ReceiptItem.fromJson()
     |
     v
Receipt object
     |
     v
ReceiptDetailsScreen
```

This provides strongly typed access such as:

```dart
receipt.receiptId
receipt.items[index].name
receipt.items[index].price
```

instead of accessing nested JSON maps throughout the UI.

## Running the Backend

From the backend directory, activate the Python virtual environment and install the required packages. The exact dependency file should be kept updated as development continues.

Example development command:

```bash
uvicorn app.main:app --reload
```

The API is then available locally at:

```text
http://localhost:8000
```

FastAPI's development documentation is available at:

```text
http://localhost:8000/docs
```

### OCR Model Download

On the first OCR run, PaddleOCR/PaddleX may download its official model files. Subsequent runs use the cached models.

## Running the Flutter App

From the Flutter project directory:

```bash
flutter pub get
flutter run
```

Check available devices with:

```bash
flutter devices
```

The current local backend URL used for iOS Simulator/macOS development is:

```dart
static const String baseUrl = "http://localhost:8000";
```

For other environments, the backend address may need to change. For example, an Android emulator commonly reaches the host machine through `10.0.2.2` rather than `localhost`.


## Roadmap

Planned development areas include:

1. Improve receipt parsing across different store layouts.
2. Add receipt history and individual receipt retrieval.
3. Extract merchant, date, subtotal, tax, discounts, and total.
4. Add item/category classification.
5. Build category-level and monthly budgets.
6. Add spending dashboards and analytics.
7. Allow users to edit/correct OCR and parser results.
8. Add authentication and user-specific data.
9. Move from SQLite to PostgreSQL when appropriate.
10. Add automated tests, load testing, Docker, CI/CD, and cloud deployment.
11. Explore email receipt ingestion and additional expense sources.
12. Add personalized insights and an interactive budget companion after the core financial data pipeline is reliable.


## Development Status

```text
[Completed] Flutter/FastAPI project setup
[Completed] Camera/gallery receipt selection
[Completed] Receipt preview
[Completed] Multipart image upload
[Completed] PaddleOCR integration
[Completed] Raw OCR extraction
[Completed] Basic item/price parser
[Completed] Receipt persistence
[Completed] Structured API response
[Completed] Flutter JSON-to-model conversion
[Completed] Receipt details UI
[In Progress] Multi-layout parser improvements
[Planned] Receipt history
[Planned] Categorization and budgets
[Planned] Analytics and AI features
```
---

**Note:** SpendWise is under active development. APIs, data models, parsing rules, and project structure may change as additional receipt formats and product features are introduced.
