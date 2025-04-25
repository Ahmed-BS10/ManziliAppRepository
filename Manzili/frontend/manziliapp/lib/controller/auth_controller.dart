import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:manziliapp/controller/category_controller.dart';
import 'package:manziliapp/model/login_model.dart';
import 'package:manziliapp/model/store_create_model.dart';
import 'package:manziliapp/model/user_create_model.dart';

class AuthController extends GetxController {
  void _handleResponse(http.Response response, {bool isLogin = false}) {
    final jsonResponse = json.decode(response.body);

    if (response.statusCode == 200 && jsonResponse['isSuccess'] == true) {
      successMessage.value = jsonResponse['message'];
      errorMessage.value = '';

      if (isLogin) {
        apiResponseData.value = jsonResponse['data'] ?? {};
      }
    } else {
      errorMessage.value = jsonResponse['message'] ?? 'Unknown error occurred';
      successMessage.value = '';
    }
  }

  void _handleError(String error) {
    errorMessage.value = 'An unexpected error occurred: $error';
    successMessage.value = '';
  }

  // Shared state
  var isLoading = false.obs;
  var successMessage = ''.obs;
  var errorMessage = ''.obs;
  var apiResponseData = {}.obs;

  // Endpoints
  final String _loginEndpoint = "http://man.runasp.net/api/Auhencation/Login";
  final String _userRegisterEndpoint =
      "http://man.runasp.net/api/Auhencation/RegsiterUser";

  // Handle user login
  Future<void> login(LoginModel loginModel) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(_loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": loginModel.Email,
          "password": loginModel.Password,
        }),
      );

      _handleResponse(response, isLogin: true);
    } catch (e) {
      _handleError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Handle user registration
  Future<void> registerUser(UserCreateModel user) async {
    isLoading.value = true;
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(_userRegisterEndpoint));
      _buildUserRequest(request, user);
      final response = await request.send();
      _handleResponse(await http.Response.fromStream(response));
    } catch (e) {
      _handleError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _buildUserRequest(
      http.MultipartRequest request, UserCreateModel user) async {
    request.fields.addAll(
        user.toMap().map((key, value) => MapEntry(key, value.toString())));

    if (user.image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('Image', user.image!.path));
    }
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  final String registerEndpoint =
      "http://man.runasp.net/api/Auhencation/RegsiterStore";

  Future<void> registerStore(StoreCreateModel storeData) async {
    isLoading.value = true;
    try {
      // Get selected category IDs from CategoryController
      final CategoryController categoryController =
          Get.find<CategoryController>();
      final selectedCategoryIds = categoryController.categories
          .where((category) => categoryController.selectedCategoryNames
              .contains(category['name']))
          .map((category) => category['id'])
          .toList();

      // Build query parameters for categories
      final queryParams =
          selectedCategoryIds.map((id) => 'categoreis=$id').join('&');

      // Prepare the request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$registerEndpoint?$queryParams'),
      );

      // Add form fields
      request.fields.addAll({
        'UserName': storeData.userName,
        'BusinessName': storeData.businessName,
        'Description': storeData.description,
        'Email': storeData.email,
        'PhoneNumber': storeData.phonenumber,
        'Address': storeData.address,
        'Password': storeData.password,
        'ConfirmPassword': storeData.confirmPassword,
        'BankAccount': storeData.bankAccount,
        'SocileMediaAcount': storeData.socileMediaAcount,
      });

      // Add image file if provided
      if (storeData.image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'Image',
          storeData.image!.path,
        ));
      }

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      // Handle the response
      if (response.statusCode == 200) {
        // final responseBody = await response.stream.bytesToString();
        // final jsonResponse = json.decode(responseBody);

        if (jsonResponse['isSuccess'] == true) {
          Get.snackbar("Success", jsonResponse['message']);
        } else {
          Get.snackbar("Error", jsonResponse['message']);
        }
      } else {
        Get.snackbar("Error", jsonResponse['message']);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
