part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

//! PICK IMAGES EVENT
class PickImagesEvent extends ProductEvent {}

//! ADD PRODUCT EVENT
class AddProductEvent extends ProductEvent {
  final String brandName;
  final String name;
  final String description;
  final String category;
  final List<File> images;
  final Set<String> weights;
  final Set<String> sizes;
  final double retailPrice;
  final double offerPrice;
  final bool isOnSale;

  AddProductEvent({
    required this.brandName,
    required this.name,
    required this.description,
    required this.category,
    required this.images,
    required this.weights,
    required this.sizes,
    required this.retailPrice,
    required this.offerPrice,
    required this.isOnSale,
  });

  @override
  List<Object> get props => [
    brandName,
        name,
        description,
        category,
        images,
        weights,
        sizes,
        retailPrice,
        offerPrice,
        isOnSale,
      ];
}

//! LOAD PRODUCT EVENT
class LoadProducts extends ProductEvent {}

//! DELETE PRODUCT EVENT
class DeleteProductEvent extends ProductEvent {
  final String productId;
  final List<String> imageUrls;

  DeleteProductEvent({required this.productId, required this.imageUrls});

  @override
  List<Object> get props => [productId, imageUrls];
}

class UpdateProductEvent extends ProductEvent {
  final String productId;
  final String brandName;
  final String name;
  final String description;
  final String category;
  final List<String> existingImageUrls;
  final List<String>? newImagePaths;
  final Set<String> weights;
  final Set<String> sizes;
  final double retailPrice;
  final double offerPrice;
  final bool isOnSale;

  UpdateProductEvent({
    required this.productId,
    required this.brandName,
    required this.name,
    required this.description,
    required this.category,
    required this.existingImageUrls,
    this.newImagePaths,
    required this.weights,
    required this.sizes,
    required this.retailPrice,
    required this.offerPrice,
    required this.isOnSale,
  });

  @override
  List<Object> get props => [
        productId,
        brandName,
        name,
        description,
        category,
        existingImageUrls,
        newImagePaths ?? [],
        weights,
        sizes,
        retailPrice,
        offerPrice,
        isOnSale,
      ];
}
