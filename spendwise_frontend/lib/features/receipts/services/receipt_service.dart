import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/receipt.dart';

class ReceiptService {
  /// Backend URL.
  ///
  /// iOS Simulator
  static const String baseUrl = "http://localhost:8000";

  /// Android Emulator
  // static const String baseUrl = "http://10.0.2.2:8000";

  /// Uploads the receipt image.
  ///
  /// Input:
  ///     Image File.
  ///
  /// Output:
  ///     Receipt object returned from FastAPI.
  Future<Receipt> uploadReceipt(
    File image,
  ) async {

    // Create multipart request.
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/receipts/upload"),
    );

    // Attach image.
    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        image.path,
      ),
    );

    // Send request.
    final streamedResponse =
        await request.send();

    // Convert streamed response
    // into normal response.
    final response =
        await http.Response.fromStream(
            streamedResponse);

    if (response.statusCode == 200) {

      final json =
          jsonDecode(response.body);

      return Receipt.fromJson(json);

    } else {

      throw Exception(
        "Failed to upload receipt.",
      );

    }
  }
}