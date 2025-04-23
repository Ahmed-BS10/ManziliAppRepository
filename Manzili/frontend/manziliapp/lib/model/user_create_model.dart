import 'dart:io';

class UserCreateModel {
  String userName;
  String email;
  String phonenumber;
  String address;
  String password;
  String confirmPassword;
  File? image;

  UserCreateModel({
    required this.userName,
    required this.email,
    required this.phonenumber,
    required this.address,
    required this.password,
    required this.confirmPassword,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      "UserName": userName,
      "Email": email,
      "PhoneNumber": phonenumber,
      "Address": address,
      "Password": password,
      "ConfirmPassword": confirmPassword,
    };
  }
}
