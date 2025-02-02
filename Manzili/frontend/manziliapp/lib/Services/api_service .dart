import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:manziliapp/core/helper/OperationResult.dart';

class ApiService {
  final String baseUrl = "http://man9.runasp.net";

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

  // // Method for multipart POST request (with files)
  // Future<ApiResponse> postMultipart(String endpoint, Map<String, dynamic> body,
  //     {File? image}) async {
  //   final url = Uri.parse('$baseUrl/$endpoint');
  //   try {
  //     var request = http.MultipartRequest('POST', url);
  //     body.forEach((key, value) {
  //       request.fields[key] = value.toString();
  //     });

  //     // Add image if present
  //     if (image != null) {
  //       request.files
  //           .add(await http.MultipartFile.fromPath('Image', image.path));
  //     }

  //     var response = await request.send();
  //     var responseData = await response.stream.bytesToString();
  //     var jsonResponse = json.decode(responseData);

  //     return ApiResponse(
  //       isSuccess: jsonResponse["isSuccess"],
  //       message: jsonResponse["message"],
  //       data: jsonResponse["data"],
  //     );
  //   } catch (e) {
  //     return ApiResponse(
  //         isSuccess: false, message: "Server error: $e", data: null);
  //   }
  // }
}
