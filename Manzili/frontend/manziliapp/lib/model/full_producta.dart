class ProductData {
  final int id;
  final String name;
  final double price;
  final String description;
  final String state;
  final int quantity;
  final String storeName;
  final String storeImage;
  final List<String>? images;

  ProductData({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.state,
    required this.quantity,
    required this.storeName,
    required this.storeImage,
    required this.images,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(), // ضمان التحويل إلى double
      description: json['description'],
      state: json['state'],
      quantity: json['quantity'],
      storeName: json['storeName'],
      storeImage: json['storeImage'],
      images: List<String>.from(json['images'] ?? [
        'http://man.runasp.net/Profile/383ba157cb9f4367b67f7baeea98097d.jpg',
        'http://man.runasp.net/Profile/383ba157cb9f4367b67f7baeea98097d.jpg'
      ]),
    );
  }

  ProductData copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? state,
    int? quantity,
    String? storeName,
    String? storeImage,
    List<String>? images,
  }) {
    return ProductData(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      state: state ?? this.state,
      quantity: quantity ?? this.quantity,
      storeName: storeName ?? this.storeName,
      storeImage: storeImage ?? this.storeImage,
      images: images ?? this.images,
    );
  }
}
