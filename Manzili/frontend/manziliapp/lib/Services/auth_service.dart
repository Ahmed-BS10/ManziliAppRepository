import 'package:manziliapp/Services/api_service%20.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService apiService = ApiService();

  Future<String> login(String email, String password) async {
    final apiService = ApiService();

    final Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    var response = await apiService.post("api/Auhencation/Login", requestBody);

    if (response.isSuccess) {
      return response.message;
    } else {
      return "Failed to login";
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
