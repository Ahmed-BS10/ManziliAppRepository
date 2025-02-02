import 'dart:convert';

import 'package:manziliapp/Services/api_service%20.dart';
import 'package:manziliapp/core/helper/OperationResult.dart';
import 'package:manziliapp/features/auhentication/model/user_create_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final ApiService apiService;

  AuthService({required this.apiService});

  Future<ApiResponse> login(String email, String password) async {
    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    var response = await apiService.post(
      "api/Auhencation/Login",
      requestBody,
    );

    if (response.isSuccess) {
      return response;
    } else {
      return response;
    }
  }

  Future<ApiResponse> register(UserCreateModel user) async {
    final url =
        Uri.parse('http://man9.runasp.net/api/Auhencation/RegsiterUser');

    try {
      var request = http.MultipartRequest('POST', url);
      user.toMap().forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (user.image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Image', user.image!.path));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      return ApiResponse(
        isSuccess: jsonResponse["isSuccess"],
        message: jsonResponse["message"],
        data: jsonResponse["data"],
      );
    } catch (e) {
      return ApiResponse(
          isSuccess: false,
          message: "Server error: ${e.toString()}",
          data: null);
    }
  }
}
