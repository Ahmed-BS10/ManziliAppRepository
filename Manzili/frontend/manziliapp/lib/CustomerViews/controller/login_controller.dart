// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:manziliapp/model/login_model.dart';

// class LoginController extends GetxController {
//   // Reactive state variables
//   var isLoading = false.obs;
//   var successMessage = ''.obs;
//   var errorMessage = ''.obs;
//   var apiResponseData = {}.obs; // To store the API response data

//   // API endpoint
//   final String loginEndpoint = "http://man.runasp.net/api/Auhencation/Login";

//   // Method to handle user login
//   Future<void> login(LoginModel loginModel) async {
//     isLoading.value = true;
//     try {
//       // Prepare the request body
//       final response = await http.post(
//         Uri.parse(loginEndpoint),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           "email": loginModel.Email,
//           "password": loginModel.Password,
//         }),
//       );

//       final jsonResponse = json.decode(response.body);

//       // Handle the response
//       if (response.statusCode == 200 && jsonResponse['isSuccess'] == true) {
//         successMessage.value = jsonResponse['message'];
//         errorMessage.value = ''; // Clear any previous error messages

//         // Store the API response data
//         apiResponseData.value = jsonResponse['data'];
//       } else {
//         errorMessage.value = jsonResponse['message'];
//         successMessage.value = ''; // Clear any previous success messages
//       }
//     } catch (e) {
//       errorMessage.value = 'حدث خطأ غير متوقع: $e';
//       successMessage.value = ''; // Clear any previous success messages
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }