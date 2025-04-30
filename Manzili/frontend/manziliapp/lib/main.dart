import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:manziliapp/controller/auth_controller.dart';
import 'package:manziliapp/controller/category_controller.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/middleware/auth_middelware.dart';
import 'package:manziliapp/providers/category_providers.dart';
import 'package:manziliapp/services/notification_service%20.dart';
import 'package:manziliapp/view/add_product_screen.dart';
import 'package:manziliapp/view/home_view.dart';
import 'package:manziliapp/view/login_view.dart';
import 'package:manziliapp/view/order_view.dart';
import 'package:manziliapp/view/profile.dart';
import 'package:manziliapp/view/register_view.dart';
import 'package:manziliapp/view/splash_view.dart';
import 'package:manziliapp/view/start_view.dart';
import 'package:manziliapp/view/store_dashboard.dart';
import 'package:manziliapp/widget/home/favorite_provider.dart';
import 'package:manziliapp/view/store_orders_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

SharedPreferences? sharedPreferences;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // 1. تأكد من تهيئة الـ Binding قبل أي استدعاء async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. تهيئة إشعارات النظام
  await _initLocalNotifications();

  // 3. سجل الـ UserController أولاً وحمّل بيانات المستخدم
  Get.put(UserController());
  await Get.find<UserController>().loadUserData();

  // 4. استخرج معرّف المستخدم (أو المتجر) بعد التحميل
  final userId = Get.find<UserController>().userId.value;

  // 5. سجل باقي الـ Controllers
  Get.put(AuthController());
  Get.put(CategoryController());

  // 6. ابدأ خدمة الـ SignalR للإشعارات
  final notificationService = NotificationService();
  await notificationService.init(userId);

  // 7. شغّل التطبيق
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _initLocalNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

Future<void> showLocalNotification(String title, String body) async {
  const androidDetails = AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    importance: Importance.max,
    priority: Priority.high,
  );
  const platformDetails = NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformDetails,
  );
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
          page: () => const SplashsView(),
          middlewares: [AuthMiddleware()],
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
    isInCart.value = true;
  }
}
