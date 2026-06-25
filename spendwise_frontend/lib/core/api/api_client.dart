import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = "http://localhost:8000"; // pointing to the url of the server

  Future<Map<String, dynamic>> getHealth() async {
    final response = await http.get(Uri.parse("$baseUrl/health"));  // sends http request and stores the response

    if (response.statusCode == 200) { // if the response is sucess then the response , or exeception
      return jsonDecode(response.body);
    }

    throw Exception("Failed to connect");
  }
}