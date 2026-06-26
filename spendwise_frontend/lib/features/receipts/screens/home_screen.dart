import 'package:flutter/material.dart';
import 'upload_receipt_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpendWise"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
          showModalBottomSheet(
          context: context,
          builder: (context) => const UploadReceiptSheet(),
          );
          },
          child: const Text('Scan Receipt'),
        ),

      ),
    );
  }
}