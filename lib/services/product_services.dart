import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wulflex_admin/models/product_model.dart';
import 'package:wulflex_admin/utils/consts/app_constants.dart';

class ProductServices {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instanceFor(bucket: bucket);

  //! GET PRODUCTS
  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  //! ADD PRODUCT TO FIREBASE
  Future<void> addProduct(ProductModel product, String customId) async {
    try {
      // creating unique doc id for the doc
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueId = '${customId}_$timestamp';

      await _firestore
          .collection('products')
          .doc(uniqueId)
          .set(product.toMap());
    } catch (error) {
      throw Exception('Failed to add product: $error');
    }
  }

  //! UPLOAD IMAGE
  Future<List<String>> uploadImages(List<File> images, String customId) async {
    List<String> downloadUrls = [];

    try {
      for (var image in images) {
        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        final ref = _storage.ref().child('product_images/$customId/$fileName');
        final uploadTask = ref.putFile(image);
        final snapShot = await uploadTask.whenComplete(() => null);
        log('IMAGE UPLOADED');
        final downloadUrl = await snapShot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return downloadUrls;
    } catch (error) {
      throw Exception('Failed to upload images: $error');
    }
  }

  //! DELETE PRODUCT
  Future<void> deleteProduct(String productId, List<String> imageUrls) async {
    try {
      // Delete product document
      await _firestore.collection('products').doc(productId).delete();

      // Delete associated images from storage
      for (String imageUrl in imageUrls) {
        try {
          // Get reference from url
          final ref = _storage.refFromURL(imageUrl);
          await ref.delete();
        } catch (imageDeleteError) {
          log('error deleting image: $imageDeleteError');
        }
      }
    } catch (deleteError) {
      throw Exception('Failed to delete product: $deleteError');
    }
  }

  //! UPDATE PRODUCT
  Future<void> updateProduct(
      ProductModel product, String productId, List<File>? newImages) async {
    try {
      List<String> updatedImageUrls = product.imageUrls;

      // Only process if new images are provided
      if (newImages != null && newImages.isNotEmpty) {
        // Delete all existing images from Firebase Storage
        for (String imageUrl in product.imageUrls) {
          try {
            final ref = _storage.refFromURL(imageUrl);
            await ref.delete();
          } catch (imageDeleteError) {
            log('Error deleting existing image: $imageDeleteError');
          }
        }

        // Upload and get new image URLs
        updatedImageUrls = await uploadImages(newImages, product.name.trim());
      }

      // Create updated product with correct image URLs
      final updatedProduct = ProductModel(
        id: productId,
        brandName: product.brandName,
        name: product.name,
        description: product.description,
        category: product.category,
        imageUrls: updatedImageUrls,
        weights: product.weights,
        sizes: product.sizes,
        retailPrice: product.retailPrice,
        offerPrice: product.offerPrice,
        isOnSale: product.isOnSale,
      );

      // Update the product in Firestore
      await _firestore
          .collection('products')
          .doc(productId)
          .update(updatedProduct.toMap());
    } catch (error) {
      throw Exception('Failed to update product: $error');
    }
  }
}
