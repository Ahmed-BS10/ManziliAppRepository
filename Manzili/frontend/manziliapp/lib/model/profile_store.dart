// ================ STORE MODEL ================
class StoreModel {
  String _id;
  String _name;
  String _email;
  String _phone;
  String _location;
  String _profileImage;
  String _password;
  String _status;
  String _description;

  StoreModel({
    required String id,
    String name = "",
    String email = "",
    required String phone,
    String location = "",
    String profileImage = "assets/images/profile.png",
    String password = "••••••••••",
    String status = "",
    String description = "",
  })  : _id = id,
        _name = name,
        _email = email,
        _phone = phone,
        _location = location,
        _profileImage = profileImage,
        _password = password,
        _status = status,
        _description = description;

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get location => _location;
  String get profileImage => _profileImage;
  String get password => _password;
  String get status => _status;
  String get description => _description;

  set name(String value) {
    _name = value;
  }

  set email(String value) {
    _email = value;
  }

  set phone(String value) {
    _phone = value;
  }

  set location(String value) {
    _location = value;
  }

  set profileImage(String value) {
    _profileImage = value;
  }

  set password(String value) {
    _password = value;
  }

  set status(String value) {
    _status = value;
  }

  set description(String value) {
    _description = value;
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
      status: _status,
      description: _description,
    );
  }

  void updateFrom(StoreModel store) {
    _name = store._name;
    _email = store._email;
    _phone = store._phone;
    _location = store._location;
    _profileImage = store._profileImage;
    _password = store._password;
    _status = store._status;
    _description = store._description;
  }

  factory StoreModel.fromApi(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'].toString(),
      name: json['userName'] ?? '', // use userName from API
      phone: json['phone'] ?? '',
      profileImage: json['image'] != null
          ? 'http://man.runasp.net${json['image']}'
          : "assets/images/profile.png",
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
    );
  }

  factory StoreModel.defaultStore() {
    return StoreModel(
      id: "1",
      name: "",
      email: "",
      phone: "",
      location: "",
      profileImage: "assets/images/profile.png",
      password: "••••••••••",
      status: "",
      description: "",
    );
  }
}