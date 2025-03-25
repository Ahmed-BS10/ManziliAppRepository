import 'package:get/get.dart';
import 'package:manziliapp/controller/register-controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
  }
}