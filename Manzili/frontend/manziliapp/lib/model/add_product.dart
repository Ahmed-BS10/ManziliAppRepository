import 'package:manziliapp/model/category_store.dart';
import 'package:manziliapp/widget/home/categorysection.dart';

class AddProduct {
  final String? id;
  final String name;
  final List<String> imageUrls;
  final CategoryStore category;
  final double price;
  final String description;

  AddProduct({
    this.id,
    required this.name,
    required this.imageUrls,
    required this.category,
    required this.price,
    required this.description,
  });

  factory AddProduct.fromJson(Map<String, dynamic> json) {
    return AddProduct(
      id: json['id'],
      name: json['name'],
      imageUrls: List<String>.from(json['imageUrls']),
      category: CategoryStore.fromJson(json['category']),
      price: json['price'].toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrls': imageUrls,
      'category': category.toJson(),
      'price': price,
      'description': description,
    };
  }
}
