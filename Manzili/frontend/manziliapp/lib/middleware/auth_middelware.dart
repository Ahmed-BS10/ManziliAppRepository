import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';
import 'package:manziliapp/main.dart';

class AuthMiddelware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (sharedPreferences!.getString("loginMessage") == null)
      return RouteSettings(name: "/home");
  }
}
