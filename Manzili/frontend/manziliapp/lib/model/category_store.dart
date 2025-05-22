class CategoryStore {
  final String id;
  final String name;

  CategoryStore({required this.id, required this.name});

  factory CategoryStore.fromJson(Map<String, dynamic> json) {
    return CategoryStore(
      id: json['id'].toString(),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
