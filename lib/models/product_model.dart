class ProductModel {
  final String? id;
  final String name;
  final String description;
  final String category;
  final List<String> imageUrls;
  final List<String> weights;
  final List<String> sizes;
  final double retailPrice;
  final double offerPrice;
  final bool isOnSale;

  ProductModel(
      {this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.imageUrls,
      required this.weights,
      required this.sizes,
      required this.retailPrice,
      required this.offerPrice,
      required this.isOnSale});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'imageUrls': imageUrls,
      'weights': weights,
      'sizes': sizes,
      'retailPrice': retailPrice,
      'offerPrice': offerPrice,
      'isOnSale': isOnSale,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      weights: List<String>.from(map['weights'] ?? []),
      sizes: List<String>.from(map['sizes'] ?? []),
      retailPrice: (map['retailPrice'] as num?)?.toDouble() ?? 0.0,
      offerPrice: (map['offerPrice'] as num?)?.toDouble() ?? 0.0,
      isOnSale: map['isOnSale'] ?? false,
    );
  }
}