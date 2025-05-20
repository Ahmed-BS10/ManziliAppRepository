import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/model/profile_store.dart';

import 'package:manziliapp/view/edit_profile_store.dart';
import 'package:manziliapp/view/start_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class StoreProvider with ChangeNotifier {
  final StoreModel _store = StoreModel.defaultStore();

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
}

class StoreProfileScreen extends StatefulWidget {
  const StoreProfileScreen({super.key});

  @override
  State<StoreProfileScreen> createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends State<StoreProfileScreen> {
  String storeStatus = 'مفتوح'; // الحالة الافتراضية

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final store = storeProvider.store;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
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
                        backgroundImage: FileImage(File(store.profileImage)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "متجر لوبي", // يمكن تعديل الاسم من البيانات
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Text("حالة المتجر: "),
                            DropdownButton<String>(
                              value: storeStatus,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              underline: const SizedBox(),
                              items: ['مفتوح', 'مغلق']
                                  .map((status) => DropdownMenuItem<String>(
                                        value: status,
                                        child: Text(status),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  storeStatus = value!;
                                });
                              },
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: const [
                              Text(
                                '"متجر 1 يقدم لك منتجات منزلية عالية الجودة مصنوعة بحب وإتقان. نوفر لك أنواع المنتجات، مثل: المأكولات..."',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _buildNavItem("تعديل الملف الشخصي", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfileStoreScreen(),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            Get.find<UserController>().clearUserData();
                            Get.offAll(() => StartView());
                          },
                          child: const Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              color: Colors.red,
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "الحساب",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: "الطلبات",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: "منتجاتي",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "الرئيسية",
            ),
          ],
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
