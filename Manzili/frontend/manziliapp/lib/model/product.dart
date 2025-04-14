
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Updated Product model with a factory constructor to parse JSON data.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image; // this will store the imageUrl from the API response
  final double rating;
  final String category;    // optional if not returned by API
  final String subCategory; // optional if not returned by API

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.rating,
    required this.category,
    required this.subCategory,
  });

  // Create a Product from JSON response. Note: some fields are set to default values if missing.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['imageUrl'] as String, // ensure the key matches the API response
      rating: 0.0,    // The API response does not include rating, so we set it to 0 or any default value
      category: '',   // If category is not provided, default is an empty string
      subCategory: '',// If subCategory is not provided, default is an empty string
    );
  }
}






