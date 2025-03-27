import 'dart:io';

class StoreCreateModel {
  String userName;
  String businessName;
  String description;
  File? image;

  String email;
  String phone;

  String address;
  String password;
  String confirmPassword;

  String socileMediaAcount;
  String bankAccount;

  StoreCreateModel({
     required this.socileMediaAcount,
     required this.email,
     required this.phone,
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
      "PhoneNumber": phone,
      "Address": address,
      "BusinessName": businessName,
      "BankAccount": bankAccount,
      "Password": password,
      "ConfirmPassword12": confirmPassword,
      "SocileMediaAcount" : socileMediaAcount,
    };
  }
}
