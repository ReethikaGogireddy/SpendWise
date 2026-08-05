import 'receipt_item.dart';

/// Represents the complete receipt returned
/// by the backend.
///
/// Example:
///
/// {
///   "receipt_id": 1,
///   "items": [ ... ]
/// }
class Receipt {
  /// Database id.
  final int receiptId;

  /// List of parsed items.
  final List<ReceiptItem> items;

  Receipt({
    required this.receiptId,
    required this.items,
  });

  /// Converts backend JSON
  /// into a Receipt object.
  factory Receipt.fromJson(
    Map<String, dynamic> json,
  ) {
    return Receipt(
      receiptId: json["receipt_id"],
      items: (json["items"] as List)
          .map(
            (item) =>
             // using the receipt_item file
                ReceiptItem.fromJson(item),
          )
          .toList(),
    );
  }
}