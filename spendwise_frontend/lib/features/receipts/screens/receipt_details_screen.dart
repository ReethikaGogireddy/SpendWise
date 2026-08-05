import 'package:flutter/material.dart';
import '../../../core/utils/item_icons.dart';
import '../models/receipt.dart';

/* 
Displays all items extracted from the receipt.

Input:
  Receipt object received from FastAPI.

Output:
  Scrollable list of receipt items.

*/
class ReceiptDetailsScreen extends StatelessWidget {
  /// Parsed receipt received from receipt.dart
  final Receipt receipt;

  const ReceiptDetailsScreen({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt Details"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // -----------------------------
          // Receipt Header
          // -----------------------------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Receipt #${receipt.receiptId}",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                const SizedBox(height: 8),

                Text(
                  "${receipt.items.length} Items Found",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // -----------------------------
          // List of parsed items
          // -----------------------------
          Expanded(
            child: ListView.separated(

              itemCount: receipt.items.length,

              separatorBuilder: (_, __) =>
                  const Divider(),

              itemBuilder: (context, index) {

                final item = receipt.items[index];

                return ListTile(

                  leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Text(
                    ItemIcons.getEmoji(item.name),
                    style: const TextStyle(fontSize: 22),
                  ),
                 ),

                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  trailing: Text(
                    "\$${item.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}