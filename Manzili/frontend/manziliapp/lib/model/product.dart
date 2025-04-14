class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final double rating;
  

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.rating,
   
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['imageUrl'] ?? '',
      rating: (json['rate'] as num?)?.toDouble() ?? 0.0,
      
    );
  }
}