import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/model/profile_store.dart';
import 'package:http/http.dart' as http;

import 'package:manziliapp/view/edit_profile_store.dart';
import 'package:manziliapp/view/start_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreProvider with ChangeNotifier {
  StoreModel _store = StoreModel.defaultStore();

  StoreModel get store => _store;

  void updateStore(StoreModel updatedStore) {
    _store.updateFrom(updatedStore);
    notifyListeners();
  }

  Future<bool> saveStore(StoreModel store) async {
    await Future.delayed(const Duration(milliseconds: 500));
    updateStore(store);
    return true;
  }

  Future<void> fetchStoreProfile({int storeId = 1}) async {
    final url = Uri.parse(
        'http://man.runasp.net/api/Store/GetProfileStore?storeId=$storeId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _store = StoreModel.fromApi(data);
      notifyListeners();
    } else {
      throw Exception('Failed to load store profile');
    }
  }
}

class StoreProfileScreen extends StatefulWidget {
  const StoreProfileScreen({super.key});

  @override
  State<StoreProfileScreen> createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends State<StoreProfileScreen> {
  String storeStatus = 'مفتوح'; // الحالة الافتراضية
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    try {
      await storeProvider.fetchStoreProfile();
      final status = storeProvider.store.status;
      setState(() {
        if (status == "Open") {
          storeStatus = 'مفتوح';
        } else if (status == "Close") {
          storeStatus = 'مغلق';
        }
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final store = storeProvider.store;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Icon(Icons.arrow_back_ios_new),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  store.profileImage.startsWith('http')
                                      ? NetworkImage(store.profileImage)
                                      : FileImage(File(store.profileImage))
                                          as ImageProvider,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              store.name, // يمكن تعديل الاسم من البيانات
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Text("حالة المتجر: "),
                                  DropdownButton<String>(
                                    value: storeStatus,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    underline: const SizedBox(),
                                    items: ['مفتوح', 'مغلق']
                                        .map((status) =>
                                            DropdownMenuItem<String>(
                                              value: status,
                                              child: Text(status),
                                            ))
                                        .toList(),
                                    onChanged: (value) async {
                                      if (value == null || value == storeStatus)
                                        return;
                                      int enStore = value == 'مفتوح' ? 1 : 2;
                                      final url = Uri.parse(
                                          'http://man.runasp.net/api/Store/ChangeStoreStatsu?storeId=1&enStore=$enStore');
                                      final response = await http.put(url);
                                      if (response.statusCode == 200) {
                                        final data = json.decode(response.body);
                                        if (data['isSuccess'] == true) {
                                          setState(() {
                                            storeStatus = value;
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'فشل في تغيير حالة المتجر')),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'خطأ في الاتصال بالخادم')),
                                        );
                                      }
                                    },
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  ),
                                  Text(
                                    store.name.isNotEmpty
                                        ? store.name
                                        : "اسم المتجر غير متوفر",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    store.location,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    store.phone,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      store.description,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  _buildNavItem("تعديل الملف الشخصي", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const EditProfileStoreScreen(),
                                      ),
                                    );
                                  }),
                                  _buildNavItem("إدارة الطلبات", () {}),
                                  _buildNavItem("المساعدة", () {}),
                                  _buildNavItem("الدعم الفني", () {}),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  Get.find<UserController>().clearUserData();
                                  Get.offAll(() => StartView());
                                },
                                child: const Text(
                                  'تسجيل الخروج',
                                  style: TextStyle(
                                    color: Color(0xffFA3636),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.chevron_left, color: Colors.grey),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
