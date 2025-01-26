import 'package:manziliapp/Services/api_service%20.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService apiService = ApiService();

  Future<bool> login(String username, String password) async {
    final response = await apiService.post('auth/login', {
      'username': username,
      'password': password,
    });

    if (response['token'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      return true;
    } else {
      return false;
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
