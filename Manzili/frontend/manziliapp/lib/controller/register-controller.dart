// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:manziliapp/model/user_create_model.dart';

// class RegisterController extends GetxController {
//   // Reactive state variables
//   var isLoading = false.obs;
//   var successMessage = ''.obs;
//   var errorMessage = ''.obs;

//   // API endpoint
//   final String registerEndpoint =
//       "http://man.runasp.net/api/Auhencation/RegsiterUser";

//   // Method to handle user registration
//   Future<void> registerUser(UserCreateModel user) async {
//     isLoading.value = true;
//     try {
//       // Prepare the request
//       var request = http.MultipartRequest('POST', Uri.parse(registerEndpoint));

//       // Add form fields
//       request.fields.addAll(
//           user.toMap().map((key, value) => MapEntry(key, value.toString())));

//       // Add image file if provided
//       if (user.image != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'Image', // Field name expected by the backend
//           user.image!.path,
//         ));
//       }

//       // Send the request
//       var response = await request.send();
//       var responseBody = await response.stream.bytesToString();
//       var jsonResponse = json.decode(responseBody);

//       // Handle the response
//       if (response.statusCode == 200) {
//         successMessage.value = jsonResponse['message'];
//         errorMessage.value = ''; // Clear any previous error messages
//       } else {
//         errorMessage.value = jsonResponse['message'];
//         successMessage.value = ''; // success messages
//       }
//     } catch (e) {
//       errorMessage.value = 'حدث خطأ غير متوقع: $e';
//       successMessage.value = ''; // Clear any previous success messages
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }




