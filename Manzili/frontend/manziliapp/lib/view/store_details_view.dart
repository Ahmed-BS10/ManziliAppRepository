import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/widget/store/storeInfo_section.dart';
import 'package:manziliapp/widget/store/store_about.dart';
import 'package:manziliapp/widget/store/store_contact.dart';
import 'package:manziliapp/widget/store/store_header.dart';
import 'package:manziliapp/widget/store/store_tabs.dart';
import 'products_view.dart';
import 'store_reviews_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StoreData {
  final int id;
  final String userName;
  final String? imageUrl;
  final String description;
  final String phoneNumber;
  final List<String> categoryNames;
  final int deliveryFee;
  final String bookTime;
  final String bankAccount;
  final String address;
  final String socileMediaAcount;
  final double rate;
  final String status;

  StoreData({
    required this.id,
    this.imageUrl,
    required this.phoneNumber,
    required this.userName,
    required this.description,
    required this.categoryNames,
    required this.deliveryFee,
    required this.bookTime,
    required this.bankAccount,
    required this.address,
    required this.socileMediaAcount,
    required this.rate,
    required this.status,
  });

  factory StoreData.fromJson(Map<String, dynamic> json) {
    return StoreData(
      id: json['id'],
      imageUrl: json['imageUrl'],
      userName: json['userName'],
      phoneNumber: json['phoneNumber'],
      description: json['description'],
      categoryNames: List<String>.from(json['categoryNames']),
      deliveryFee: json['deliveryFee'],
      bookTime: json['bookTime'],
      bankAccount: json['bankAccount'],
      address: json['address'],
      socileMediaAcount: json['socileMediaAcount'],
      rate: json['rate'].toDouble() ?? 0.0,
      status: json['status'],
    );
  }
}

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({super.key, required this.storeId});

  final int storeId;

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  int _selectedTabIndex = 0; // Default to about tab (عن المتجر)
  late Future<StoreData> _storeDetailsFuture;

  @override
  void initState() {
    super.initState();
    _storeDetailsFuture = _fetchStoreDetails();
  }

  Future<StoreData> _fetchStoreDetails() async {
    final response = await http.get(
      Uri.parse(
          'http://man.runasp.net/api/Store/GetInfoStore?storeId=${widget.storeId}'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse["isSuccess"] == true) {
        return StoreData.fromJson(jsonResponse["data"]);
      } else {
        throw Exception("Error: ${jsonResponse["message"]}");
      }
    } else {
      throw Exception("Failed to load: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<StoreData>(
          future: _storeDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No data available."));
            } else {
              final storeData = snapshot.data!;
              return Column(
                children: [
                  // Header with back button, logo, and cart
                  StoreHeader(
                    deliveryFee: storeData.deliveryFee,
                    storeId: storeData.id,
                    userId: Get.find<UserController>().userId.value,
                    imageUrl: storeData
                        .imageUrl, // Replace with actual image URL if available
                  ),

                  // Store info (favorite, rating, name) and category display
                  StoreInfoSection(
                    rate: storeData.rate.toInt(),
                    businessName: storeData.userName,
                    categoryNames: storeData.categoryNames,
                  ),

                  // Navigation tabs
                  StoreTabs(
                    selectedTabIndex: _selectedTabIndex,
                    onTabSelected: (index) {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    status: storeData.status,
                    addrees: storeData.address,
                  ),

                  // Main content based on selected tab
                  Expanded(
                    child: _buildTabContent(storeData),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabContent(StoreData storeData) {
    switch (_selectedTabIndex) {
      case 0: // About store (عن المتجر)
        return SingleChildScrollView(
          child: Column(
            children: [
              StoreAbout(
                description: storeData.description,
                bookTime: storeData.bookTime,
              ),
              StoreContact(
                socileMediaAcount: storeData.socileMediaAcount,
                phoneNumberl: storeData.phoneNumber,
              ),
            ],
          ),
        );
      case 1: // Reviews (تقييمات المتجر)
        return StoreReviewsView(
          storeId: storeData.id,
        );
      case 2: // Store policy (سياسة المتجر)
        return const Center(
          child: Text('محتوى قيد التطوير'),
        );
      case 3: // Products (منتجاتنا)
        return ProductsView(
          categoryNames: storeData.categoryNames,
          storeid: storeData.id,
        );
      default:
        return const Center(
          child: Text('محتوى قيد التطوير'),
        );
    }
  }
}
