import 'package:flutter/material.dart';
import 'package:manziliapp/features/home/view/homeview.dart';
import 'package:manziliapp/features/auhentication/view/login_view.dart';
import 'package:manziliapp/features/auhentication/view/register_view.dart';
import 'package:manziliapp/features/home/view/widget/favorite_provider.dart';

import 'package:provider/provider.dart';

// In your main.dart or wherever you set up your providers:
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        // other providers...
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeView(),
    );
  }
}










class ManziliApp extends StatelessWidget {
  const ManziliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeView(),
        'login': (context) => LoginView(),
        'register': (context) => RegisterView(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}




// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   UserCreateModel newUser = UserCreateModel(
//     firstName: "Ali",
//     lastName: "Ahmed",
//     email: "ali.com",
//     phone: "+934567",
//     city: "المكلا",
//     address: "الديس - الدائرة",
//     userName: "8789789",
//     password: "777Aa@",
//     confirmPassword: "777Aa@",
//   );

//   final AuthService authService = AuthService(apiService: ApiService());

//   // Pick Image from Gallery
//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         newUser.image = File(pickedFile.path);
//       });
//     }
//   }

//   // Register the user after picking the image
//   Future<void> _registerUser() async {
//     var response = await authService.Userregister(newUser);
//     print(response.isSuccess);
//     print(response.message);
//     print(response.data);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text("Register User")),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey[300],
//                 backgroundImage:
//                     newUser.image != null ? FileImage(newUser.image!) : null,
//                 child: newUser.image == null
//                     ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _registerUser,
//               child: const Text("Register"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
