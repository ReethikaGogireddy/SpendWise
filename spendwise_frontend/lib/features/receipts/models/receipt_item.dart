/// Represents one item extracted from the receipt.
///
/// Example:
/// {
///   "name": "BANANA CAVENDISH",
///   "price": 1.32
/// }
class ReceiptItem {
  /// Item name.
  final String name;

  /// Item price.
  final double price;

  ReceiptItem({
    required this.name,
    required this.price,
  });

  /// Converts JSON received from FastAPI
  /// into a ReceiptItem object.
  factory ReceiptItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReceiptItem(
      name: json["name"],
      price: (json["price"] as num).toDouble(),
    );
  }
}