import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/CustomerViews/controller/auth_controller.dart';
import 'package:manziliapp/CustomerViews/controller/category_controller.dart';
import 'package:manziliapp/CustomerViews/controller/user_controller.dart';
import 'package:manziliapp/CustomerViews/view/order_detalis_view.dart';
import 'package:manziliapp/CustomerViews/view/order_view.dart';
import 'package:manziliapp/CustomerViews/view/home_view.dart';
import 'package:manziliapp/CustomerViews/view/login_view.dart';
import 'package:manziliapp/CustomerViews/view/profile.dart';
import 'package:manziliapp/CustomerViews/view/register_view.dart';
import 'package:manziliapp/CustomerViews/widget/home/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تسجيل UserController قبل تشغيل التطبيق
  Get.put(UserController());

  // يمكن تحميل البيانات المحفوظة عند بدء التطبيق إن رغبت
  await Get.find<UserController>().loadUserData();

  Get.put(AuthController());
  Get.put(CategoryController());
  Get.put(UserController());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/sp',
      getPages: [
        GetPage(
          name: '/sp',
          page: () => const OrderDetailsView(),
          // middlewares: [AuthMiddleware()]
        ),
        GetPage(
          name: '/login',
          page: () => const LoginView(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeView(),
        ),
      ],
    );
  }
}

class CartController extends GetxController {
  var isInCart = true.obs;
  var isLoading = false.obs;

  void toggleCartState() {
    isInCart.value = !isInCart.value;
  }

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void removeFromCart() {
    isInCart.value = false;
  }
}
