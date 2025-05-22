import 'dart:io';

class StoreCreateModel {
  String userName;
  String description;
  String email;
  String phonenumber;
  String address;
  String? bookTime;

  File? image;

  String password;
  String confirmPassword;

  String socileMediaAcount;
  String bankAccount;

  StoreCreateModel({
    this.bookTime,
    required this.socileMediaAcount,
    required this.email,
    required this.phonenumber,
    required this.address,
    required this.userName,
    required this.password,
    required this.confirmPassword,
    required this.bankAccount,
    required this.description,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      "BookTime": bookTime,
      "UserName": userName,
      "Email": email,
      "Description": description,
      "PhoneNumber": phonenumber,
      "Address": address,
      "BankAccount": bankAccount,
      "Password": password,
      "ConfirmPassword": confirmPassword,
      "SocileMediaAcount": socileMediaAcount,
    };
  }
}
