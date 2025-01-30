import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manziliapp/core/helper/OperationResult.dart';

class ApiService {
  final String baseUrl = "http://man2.runasp.net";

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<ApiResponse> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);
      return ApiResponse(
          isSuccess: responseData["isSuccess"],
          message: responseData["message"],
          data: responseData["data"]);
    } catch (e) {
      return ApiResponse(isSuccess: false, message: "Server error", data: null);
    }
  }
}
