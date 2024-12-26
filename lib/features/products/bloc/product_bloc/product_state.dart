part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

//! PRODUCT INITIAL STATE
final class ProductInitial extends ProductState {}

//! PRODUCT LOADING STATE
class ProductLoading extends ProductState {}

//! PRODUCT LOADED STATE
class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

//! IMAGE PICKED SUCCESS STATE
class ImagesPickedSuccess extends ProductState {
  final List<String> imagePaths;

  ImagesPickedSuccess(this.imagePaths);

  @override
  List<Object> get props => [imagePaths];
}

//! PRODUCT ADD SUCCESS STATE
class ProductAddSuccess extends ProductState {}

//! PRODUCT ERROR STATE
class ProductError extends ProductState {
  final String message;

  ProductError(this.message);

  @override
  List<Object> get props => [message];
}

//! IMAGE PICKED ERROR STATE
class ImagePickError extends ProductState {
  final String message;

  ImagePickError(this.message);

  @override
  List<Object> get props => [message];
}

//! TRACK IMAGE UPLOAD PROGRESS
class ImageUploadProgress extends ProductState {
  final double progress;
  final File selectedImage;

  ImageUploadProgress({required this.progress, required this.selectedImage});

  @override
  List<Object> get props => [progress, selectedImage];
}

//! PRODUCT DELETE SUCCESS
class ProductDeleteSuccess extends ProductState {}

//! PRODUCT UPDATED SUCCESS
class ProductUpdateSuccess extends ProductState {}
