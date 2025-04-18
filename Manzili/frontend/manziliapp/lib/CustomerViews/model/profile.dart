// ================ USER MODEL ================
class UserModel {
  String _id;
  String _name;
  String _email;
  String _phone;
  String _location;
  String _profileImage;
  String _password;

  UserModel({
    required String id,
    required String name,
    required String email,
    required String phone,
    String location = "",
    String profileImage = "assets/images/profile.png",
    String password = "••••••••••",
  })  : _id = id,
        _name = name,
        _email = email,
        _phone = phone,
        _location = location,
        _profileImage = profileImage,
        _password = password;

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get location => _location;
  String get profileImage => _profileImage;
  String get password => _password;

  set name(String value) {
    if (value.trim().isNotEmpty) {
      _name = value;
    }
  }

  set email(String value) {
    if (value.contains('@')) {
      _email = value;
    }
  }

  set phone(String value) {
    if (RegExp(r'^\d+$').hasMatch(value)) {
      _phone = value;
    }
  }

  set location(String value) {
    _location = value;
  }

  set profileImage(String value) {
    _profileImage = value;
  }

  set password(String value) {
    if (value.length >= 8) {
      _password = value;
    }
  }

  UserModel clone() {
    return UserModel(
      id: _id,
      name: _name,
      email: _email,
      phone: _phone,
      location: _location,
      profileImage: _profileImage,
      password: _password,
    );
  }

  void updateFrom(UserModel user) {
    _name = user._name;
    _email = user._email;
    _phone = user._phone;
    _location = user._location;
    _profileImage = user._profileImage;
    _password = user._password;
  }

  factory UserModel.defaultUser() {
    return UserModel(
      id: "1",
      name: "Ahmed salim",
      email: "Asalim@gmail.com",
      phone: "7175656548",
      location: "قوة المتصررين",
    );
  }
}