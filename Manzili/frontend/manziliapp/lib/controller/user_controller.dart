import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var userId = 0.obs;
  var userToken = ''.obs;

  // حفظ البيانات في SharedPreferences
  Future<void> saveUserData(int id, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', id);
    await prefs.setString('userToken', token);

    // تحديث الحالة
    userId.value = id;
    userToken.value = token;
  }

  // تحميل البيانات عند بدء التطبيق
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getInt('userId') ?? 0;
    userToken.value = prefs.getString('userToken') ?? '';
  }


  // مسح بيانات المستخدم من SharedPreferences وتحديث الحالة
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userToken');

    // إعادة تعيين الحالة
    userId.value = 0;
    userToken.value = '';
  }
}
