import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/api/api_client.dart';

class ReceiptPreviewScreen extends StatefulWidget {
  const ReceiptPreviewScreen({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  State<ReceiptPreviewScreen> createState() => _ReceiptPreviewScreenState();
}

class _ReceiptPreviewScreenState extends State<ReceiptPreviewScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isUploading = false;

  Future<void> _uploadReceipt() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final result = await _apiClient.uploadReceipt(widget.imagePath);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploaded: ${result["merchant_name"] ?? "Receipt"}')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload error: $e')),
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