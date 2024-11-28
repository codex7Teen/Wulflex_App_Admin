import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wulflex_admin/models/product_model.dart';
import 'package:wulflex_admin/services/product_services.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductServices _productServices;
  final ImagePicker _imagePicker;
  ProductBloc(this._productServices, this._imagePicker)
      : super(ProductInitial()) {
    //! PICK IMAGES BLOC
    on<PickImagesEvent>((event, emit) async {
      try {
        emit(ProductLoading());
        final List<XFile> images =
            await _imagePicker.pickMultiImage(imageQuality: 80);

        if (images.length > 4) {
          emit(ProductError('You can only select up to 4 images!'));
          return;
        }

        final List<String> imagePaths =
            images.map((image) => image.path).toList();
        emit(ImagesPickedSuccess(imagePaths));
      } catch (error) {
        emit(ProductError('Failed to pick images: $error'));
      }
    });

    //! ADD PRODUCT BLOC
    on<AddProductEvent>((event, emit) async {
      try {
        emit(ProductLoading());

        // Upload images first
        final List<String> imageUrls = await _productServices.uploadImages(
          event.images,
          event.name.trim(),
        );

        // Create product model
        final newProduct = ProductModel(
          brandName: event.brandName.trim(),
          name: event.name.trim(),
          description: event.description.trim(),
          category: event.category,
          imageUrls: imageUrls,
          weights: event.weights.toList(),
          sizes: event.sizes.toList(),
          retailPrice: event.retailPrice,
          offerPrice: event.offerPrice,
          isOnSale: event.isOnSale,
        );

        // Add product to Firebase
        await _productServices.addProduct(newProduct, event.name.trim());

        emit(ProductAddSuccess());
      } catch (error) {
        emit(ProductError('Failed to upload product: $error'));
      }
    });

    //! GET PRODUCT BLOC
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        await emit.forEach(
          _productServices.getProducts(),
          onData: (List<ProductModel> products) => ProductLoaded(products),
          onError: (error, stackTrace) => ProductError(error.toString()),
        );
      } catch (error) {
        emit(ProductError(error.toString()));
      }
    });

    //! DELETE PRODUCT BLOC
    on<DeleteProductEvent>((event, emit) async {
      try {
        await _productServices.deleteProduct(event.productId, event.imageUrls);
        // Emit delete success without changing the current products state
        emit(ProductDeleteSuccess());
        // Re-emit the previous state with products
        if (state is ProductLoaded) {
          emit(state);
        }
      } catch (error) {
        emit(ProductError('Failed to delete product: $error'));
        // Re-emit the previous state with products
        if (state is ProductLoaded) {
          emit(state);
        }
      }
    });

    //! UPDATE PRODUCT EVENT
    on<UpdateProductEvent>((event, emit) async {
      try {
        emit(ProductLoading());

        // Create product model with updated details
        final updatedProduct = ProductModel(
          brandName: event.brandName.trim(),
          name: event.name.trim(),
          description: event.description.trim(),
          category: event.category,
          imageUrls: event.existingImageUrls,
          weights: event.weights.toList(),
          sizes: event.sizes.toList(),
          retailPrice: event.retailPrice,
          offerPrice: event.offerPrice,
          isOnSale: event.isOnSale,
        );

        // Convert new image paths to files
        List<File>? newImageFiles;
        if (event.newImagePaths != null) {
          newImageFiles =
              event.newImagePaths!.map((path) => File(path)).toList();
        }

        // Update product in Firebase
        await _productServices.updateProduct(
            updatedProduct, event.productId, newImageFiles);

        emit(ProductUpdateSuccess());
      } catch (error) {
        emit(ProductError('Failed to update product: $error'));
      }
    });
  }
}
