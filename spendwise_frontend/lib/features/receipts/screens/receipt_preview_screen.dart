import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';
import 'receipt_details_screen.dart';

class ReceiptPreviewScreen extends StatefulWidget {

  // taking 2 inputs, imagepath
  const ReceiptPreviewScreen({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  State<ReceiptPreviewScreen> createState() => _ReceiptPreviewScreenState();
}

class _ReceiptPreviewScreenState extends State<ReceiptPreviewScreen> {
  // creating an object for apiClient
  final ApiClient _apiClient = ApiClient();
  // boolean value 
  bool _isUploading = false;


// this is the screen own function 
  Future<void> _uploadReceipt() async { 

  setState(() {
    _isUploading = true;
  });

  try {
    // sending the receipt ( image address)  to apiclient function
    // which uploads the data to the backend and then processes it
    // and receipt holds receipt object
    final receipt =
        await _apiClient.uploadReceipt(
      widget.imagePath,
    );

    if (!mounted) return;

   // navigate to ReceiptDetailsScreen, with receipt
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ReceiptDetailsScreen(
          receipt: receipt,
        ),
      ),
    );

  } catch (e) {

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );

  } finally {

    if (mounted) {

      setState(() {
        _isUploading = false;
      });

    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt Preview"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadReceipt,
                child: Text(_isUploading ? "Uploading..." : "Upload Receipt"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}