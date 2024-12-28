import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String weightRange;
  final double rating;
  final int totalReviews;
  final String deliveryTime;
  final int quantity;
  final String category;
  final bool isAvailable;
  final double discount;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.weightRange,
    required this.rating,
    required this.totalReviews,
    required this.deliveryTime,
    required this.quantity,
    required this.category,
    required this.isAvailable,
    required this.discount,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? 'No Name',
      description: map['description'] ?? 'No Description',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      weightRange: map['weightRange'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      deliveryTime: map['deliveryTime'] ?? '',
      quantity: map['quantity'] ?? 0,
      category: map['category'] ?? 'Uncategorized',
      isAvailable: map['isAvailable'] ?? true,
      discount: (map['discount'] ?? 0).toDouble(),
    );
  }
}
