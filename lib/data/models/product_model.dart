import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final int quantity;
  final String brandName;
  final String name;
  final String description;
  final String category;
  final List<String> imageUrls;
  final List<String> weights;
  final List<String> sizes;
  final double retailPrice;
  final double offerPrice;
  final bool isOnSale;
  final DateTime createdAt;
  final String? selectedWeight;
  final String? selectedSize;

  ProductModel({
    this.id,
    // default product quantity to 1
    this.quantity = 1,
    required this.brandName,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrls,
    required this.weights,
    required this.sizes,
    required this.retailPrice,
    required this.offerPrice,
    required this.isOnSale,
    this.selectedWeight,
    this.selectedSize,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'brandName': brandName,
      'quantity': quantity,
      'name': name,
      'description': description,
      'category': category,
      'imageUrls': imageUrls,
      'weights': weights,
      'sizes': sizes,
      'retailPrice': retailPrice,
      'offerPrice': offerPrice,
      'isOnSale': isOnSale,
      'selectedWeight': selectedWeight,
      'selectedSize': selectedSize,
      'createdAt': createdAt
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return ProductModel(
        id: id,
        quantity: map['quantity'] ?? 1,
        brandName: map['brandName'] ?? '',
        name: map['name'] ?? '',
        description: map['description'] ?? '',
        category: map['category'] ?? '',
        imageUrls: List<String>.from(map['imageUrls'] ?? []),
        weights: List<String>.from(map['weights'] ?? []),
        sizes: List<String>.from(map['sizes'] ?? []),
        retailPrice: (map['retailPrice'] as num?)?.toDouble() ?? 0.0,
        offerPrice: (map['offerPrice'] as num?)?.toDouble() ?? 0.0,
        isOnSale: map['isOnSale'] ?? false,
        selectedWeight: map['selectedWeight'],
        selectedSize: map['selectedSize'],
        createdAt:
            (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now());
  }
}
