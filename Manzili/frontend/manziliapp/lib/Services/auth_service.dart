import 'package:manziliapp/Services/api_service%20.dart';
import 'package:manziliapp/core/helper/OperationResult.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}
