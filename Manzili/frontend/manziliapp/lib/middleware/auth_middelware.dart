import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:manziliapp/CustomerViews/controller/user_controller.dart';

class AuthMiddleware extends GetMiddleware {
  // The priority field determines the order of middleware execution (lower values run first)
  @override
  int? priority = 1;

  @override
  RouteSettings? redirect(String? route) {
    // Access the UserController instance
    final UserController userController = Get.find<UserController>();

    // If userToken is empty, user is not authenticated, so redirect to login page.
    if (userController.userToken.value.isNotEmpty) {
      return const RouteSettings(name: '/home');
    }
    // Otherwise, no redirection is needed.
    return null;
  }
}
