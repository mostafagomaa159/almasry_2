part of '../../../core_imports.dart';

class ProductResponse {
  final int id;
  final String name;
  final String image;
  final double price;

  ProductResponse({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
