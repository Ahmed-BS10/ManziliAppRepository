import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:manziliapp/controller/user_controller.dart';
import 'package:manziliapp/model/profile.dart';
import 'package:manziliapp/view/edit_profile.dart';
import 'package:manziliapp/view/start_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ================ USER PROVIDER ================
class UserProvider with ChangeNotifier {
  final UserModel _user = UserModel.defaultUser();

  UserModel get user => _user;

  void updateUser(UserModel updatedUser) {
    _user.updateFrom(updatedUser);
    notifyListeners();
  }

  Future<bool> saveUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    updateUser(user);
    return true;
  }
}

// ================ WIDGETS ================
class NavigationItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const NavigationItem({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.chevron_left,
              color: Colors.grey,
              size: 24,
            ),
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

// ================ SCREENS ================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(File(user.profileImage)),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
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
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfileScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'تعديل',
                                    style: TextStyle(
                                      color: Color(0xff1548C7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              user.email,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.phone,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            NavigationItem(
                              label: 'طلباتي',
                              onTap: () {},
                            ),
                            NavigationItem(
                              label: 'المتاجر المفضلة',
                              onTap: () {},
                            ),
                            NavigationItem(
                              label: 'مركز المساعدة',
                              onTap: () {},
                            ),
                            NavigationItem(
                              label: 'الدعم الفني',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextButton(
                          onPressed: () async {
                            // Clear all data in SharedPreferences
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();

                            // Clear user data and navigate to StartView
                            Get.find<UserController>().clearUserData();
                            Get.offAll(() => StartView());
                          },
                          child: const Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              color: Color(0xffFA3636),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
}
