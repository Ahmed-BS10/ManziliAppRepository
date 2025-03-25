import 'dart:convert';
import 'package:manziliapp/Services/api_service%20.dart';
import 'package:manziliapp/core/helper/OperationResult.dart';
import 'package:manziliapp/model/store_create_model.dart';
import 'package:manziliapp/model/user_create_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final ApiService apiService;

  AuthService({required this.apiService});

  Future<ApiResponse> login(String email, String password) async {
    final Map<String, dynamic> requestBody = {
      "Email": email,
      "Password": password,
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

  Future<ApiResponse> Userregister(UserCreateModel user) async {
    final url =
        Uri.parse('http://man.runasp.net/api/User/Create');

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

  Future<ApiResponse> Storeregister(StoreCreateModel store) async {
    final url =
        Uri.parse('http://man9.runasp.net/api/Auhencation/RegsiterStore');

    try {
      var request = http.MultipartRequest('POST', url);
      store.toMap().forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (store.image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Image', store.image!.path));
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
