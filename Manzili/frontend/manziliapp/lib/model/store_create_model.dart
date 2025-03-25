import 'dart:io';

class StoreCreateModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String city;
  String address;
  String userName;
  String password;
  String confirmPassword;
  String businessName;
  String bankAccount;
  String status;
  File? image;

  StoreCreateModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.address,
    required this.userName,
    required this.password,
    required this.confirmPassword,
    required this.businessName,
    required this.bankAccount,
    required this.status,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      "FirstName": firstName,
      "LastName": lastName,
      "UserName": userName,
      "Email": email,
      "PhoneNumber": phone,
      "City": city,
      "Address": address,
      "BusinessName": businessName,
      "BankAccount": bankAccount,
      "Status": status,
      "Password": password,
      "ConfirmPassword": confirmPassword,
    };
  }
}
