import 'dart:io';

class UserCreateModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String city;
  String address;
  String userName;
  String password;
  String confirmPassword;
  File? image;

  UserCreateModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.address,
    required this.userName,
    required this.password,
    required this.confirmPassword,
    this.image,
  });

  /// ✅ **تحويل البيانات إلى `Map<String, String>` لإرسالها في `API`**
  Map<String, dynamic> toMap() {
    return {
      "FirstName": firstName,
      "LastName": lastName,
      "UserName": userName,
      "Email": email,
      "PhoneNumber": phone,
      "City": city,
      "Address": address,
      "Password": password,
      "ConfirmPassword": confirmPassword,
    };
  }
}
