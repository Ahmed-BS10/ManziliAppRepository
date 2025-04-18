// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:manziliapp/controller/user_controller.dart';
// import 'package:manziliapp/model/store_modle.dart';
// import 'package:manziliapp/core/helper/app_colors.dart';

// class StoreController extends GetxController {
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//   var stores = <StoreModle>[].obs;

//   Future<void> fetchStores({
//     int? category,
//     String? filter,
//     String? searchQuery,
//   }) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       String url;

//       // Check for search query first
//       if (searchQuery != null && searchQuery.isNotEmpty) {
//         // Use the search API. Make sure you URL-encode searchQuery if needed.
//         final encodedQuery = Uri.encodeComponent(searchQuery);
//         url =
//             "http://man.runasp.net/api/Store/SearchStoreByName?businessName=$encodedQuery";
//       } else if (filter != null) {
//         switch (filter) {
//           case "المفضلة":
//             url =
//                 "http://man.runasp.net/api/Store/GetUserFavoriteStores?userId=${Get.find<UserController>().userId.value}";
//             break;
//           case "الجديدة":
//             url = "http://man.runasp.net/api/Store/OrderByDescending";
//             break;
//           case "الكل":
//             url = "http://man.runasp.net/api/Store/ToPage?size=0&pageSize=0";
//             break;
//           default:
//             url = "http://man.runasp.net/api/Store/ToPage?size=0&pageSize=0";
//         }
//       } else if (category != null) {
//         url =
//             "http://man.runasp.net/api/Store/StoresByCategore?storecCategoryId=$category";
//       } else {
//         url = "http://man.runasp.net/api/Store/ToPage?size=0&pageSize=0";
//       }

//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonResponse = json.decode(response.body);
//         if (jsonResponse["isSuccess"] == true) {
//           stores.value = (jsonResponse["data"] as List)
//               .map((item) => StoreModle.fromJson(item))
//               .toList();
//         } else {
//           errorMessage.value = jsonResponse["message"];
//         }
//       } else {
//         errorMessage.value = "Failed to load: ${response.statusCode}";
//       }
//     } catch (e) {
//       errorMessage.value = "An error occurred: $e";
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Map<String, dynamic> mapStatus(String status) {
//     if (status.toLowerCase() == "open") {
//       return {"text": "مفتوح", "color": AppColors.openStatus};
//     } else if (status.toLowerCase() == "closed") {
//       return {"text": "مغلق", "color": AppColors.closedStatus};
//     }
//     return {"text": status, "color": Colors.grey};
//   }
// }
