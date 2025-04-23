import 'dart:io';

class StoreCreateModel {
  String userName;
  String description;
  String email;
  String phonenumber;
  String address;

  File? image;

  String password;
  String confirmPassword;

  String businessName;
  String socileMediaAcount;
  String bankAccount;

  StoreCreateModel({
    required this.socileMediaAcount,
    required this.email,
    required this.phonenumber,
    required this.address,
    required this.userName,
    required this.password,
    required this.confirmPassword,
    required this.businessName,
    required this.bankAccount,
    required this.description,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      "UserName": userName,
      "Email": email,
      "Description": description,
      "PhoneNumber": phonenumber,
      "Address": address,
      "BusinessName": businessName,
      "BankAccount": bankAccount,
      "Password": password,
      "ConfirmPassword12": confirmPassword,
      "SocileMediaAcount": socileMediaAcount,
    };
  }
}
