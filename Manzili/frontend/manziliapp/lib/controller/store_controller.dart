// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:manziliapp/model/store_create_model.dart';
// import 'package:manziliapp/controller/category_controller.dart';

// class StoreController extends GetxController {
//   var isLoading = false.obs; // Loading state
//   final String registerEndpoint =
//       "http://man.runasp.net/api/Auhencation/RegsiterStore";

//   // Register store
//   Future<void> registerStore(StoreCreateModel storeData) async {
//     isLoading.value = true;
//     try {
//       // Get selected category IDs from CategoryController
//       final CategoryController categoryController =
//           Get.find<CategoryController>();
//       final selectedCategoryIds = categoryController.categories
//           .where((category) => categoryController.selectedCategoryNames
//               .contains(category['name']))
//           .map((category) => category['id'])
//           .toList();

//       // Build query parameters for categories
//       final queryParams =
//           selectedCategoryIds.map((id) => 'categoreis=$id').join('&');

//       // Prepare the request
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('$registerEndpoint?$queryParams'),
//       );

//       // Add form fields
//       request.fields.addAll({
//         'UserName': storeData.userName,
//         'BusinessName': storeData.businessName,
//         'Description': "hi my ",
//         'Email': storeData.email,
//         'PhoneNumber': storeData.phone,
//         'Address': storeData.address,
//         'Password': storeData.password,
//         'ConfirmPassword12': storeData.confirmPassword,
//         'BankAccount': storeData.bankAccount,
//         'SocileMediaAcount': "good",
//       });

//       // Add image file if provided
//       if (storeData.image != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'Image',
//           storeData.image!.path,
//         ));
//       }

//       // Send the request
//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//       final jsonResponse = json.decode(responseBody);

//       // Handle the response
//       if (response.statusCode == 200) {
//         // final responseBody = await response.stream.bytesToString();
//         // final jsonResponse = json.decode(responseBody);

//         if (jsonResponse['isSuccess'] == true) {
//           Get.snackbar("Success", jsonResponse['message']);
//         } else {
//           Get.snackbar("Error", jsonResponse['message']);
//         }
//       } else {
//          Get.snackbar("Error", jsonResponse['message']);
//       }
//     } catch (e) {
//       Get.snackbar("Error", "An unexpected error occurred: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
