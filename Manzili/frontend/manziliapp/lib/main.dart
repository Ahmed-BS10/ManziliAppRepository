import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manziliapp/Services/api_service%20.dart';
import 'package:manziliapp/Services/auth_service.dart';
import 'package:manziliapp/features/auhentication/model/user_create_model.dart';
import 'package:manziliapp/features/auhentication/view/login_view.dart';
import 'package:manziliapp/features/auhentication/view/register_view.dart';
import 'package:manziliapp/features/start/view/start_view.dart';

void main() async {
  runApp(ManziliApp());
}

class ManziliApp extends StatelessWidget {
  const ManziliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => StartView(),
        'login': (context) => LoginView(),
        'register': (context) => RegisterView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  UserCreateModel newUser = UserCreateModel(
    firstName: "Ali",
    lastName: "Ahmed",
    email: "ali.com",
    phone: "+934567",
    city: "المكلا",
    address: "الديس - الدائرة",
    userName: "8789789",
    password: "777Aa@",
    confirmPassword: "777Aa@",
  );

  final AuthService authService = AuthService(apiService: ApiService());

  // Pick Image from Gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        newUser.image = File(pickedFile.path);
      });
    }
  }

  // Register the user after picking the image
  Future<void> _registerUser() async {
    var response = await authService.Userregister(newUser);
    print(response.isSuccess);
    print(response.message);
    print(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Register User")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    newUser.image != null ? FileImage(newUser.image!) : null,
                child: newUser.image == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
