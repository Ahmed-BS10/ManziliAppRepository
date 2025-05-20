// ================ STORE MODEL ================
class StoreModel {
  String _id;
  String _name;
  String _email;
  String _phone;
  String _location;
  String _profileImage;
  String _password;

  StoreModel({
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

  StoreModel clone() {
    return StoreModel(
      id: _id,
      name: _name,
      email: _email,
      phone: _phone,
      location: _location,
      profileImage: _profileImage,
      password: _password,
    );
  }

  void updateFrom(StoreModel store) {
    _name = store._name;
    _email = store._email;
    _phone = store._phone;
    _location = store._location;
    _profileImage = store._profileImage;
    _password = store._password;
  }

  factory StoreModel.defaultStore() {
    return StoreModel(
      id: "1",
      name: "ali abdullah",
      email: "Asalim@gmail.com",
      phone: "7175656548",
      location: "قوة المتصررين",
    );
  }
}