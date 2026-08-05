import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/receipts/models/receipt.dart';

class ApiClient {
  static const String baseUrl = "http://localhost:8000"; // pointing to the url of the server

  Future<Map<String, dynamic>> getHealth() async {
    final response = await http.get(Uri.parse("$baseUrl/health"));  // sends http request and stores the response

    if (response.statusCode == 200) { // if the response is sucess then the response , or exeception
      return jsonDecode(response.body);
    }

    throw Exception("Failed to connect");
  }

  /// Uploads a receipt image to the backend.
///
/// Input:
///     Local image path.
///
/// Output:
///     Receipt object returned from FastAPI.
Future<Receipt> uploadReceipt(
  String imagePath,
  // takes the image path
) async {

  // Create HTTP multipart request.
  final request = http.MultipartRequest(
    "POST",
    Uri.parse("$baseUrl/receipts/upload"),
  );

  // Attach the image.
  request.files.add(
    await http.MultipartFile.fromPath(
      "file",
      imagePath,
    ),
  );

  // Send request.
  final streamedResponse =
      await request.send();

  // Convert streamed response into
  // a normal HTTP response.
  final response =
      await http.Response.fromStream(
    streamedResponse,
  );

  if (response.statusCode == 200) {

    final json =
        jsonDecode(response.body);

    // Convert JSON into a Receipt object.
    return Receipt.fromJson(json);

  }

  throw Exception(
    "Upload failed: ${response.body}",
  );
}
}