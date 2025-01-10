import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wulflex_admin/core/config/app_constants.dart';

class CategoryServices {
  final _firestore = FirebaseFirestore.instance;
  final _fireStorage = FirebaseStorage.instanceFor(bucket: bucket);

  // Default categories that should always appear
  static const List<String> defaultCategories = [
    'Equipments',
    'Supplements',
    'Accessories',
    'Apparels',
  ];

  //! Add a new category
  Future<void> addCategory(String categoryName, File imageFile) async {
    try {
      // Check if category already exists in defaults
      if (defaultCategories.contains(categoryName)) {
        throw Exception('This category already exists in default categories');
      }

      // Upload image to Firebase Storage
      final storageRef =
          _fireStorage.ref().child('category_images/$categoryName');
      final uploadTask = await storageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore.collection('custom_categories').add({
        'name': categoryName,
        'image_url': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      throw Exception('Failed to add category: $error');
    }
  }

  //! Get all categories
  Stream<List<String>> getCategories() {
    return _firestore
        .collection('custom_categories')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      // Get custom categories from Firebase, preserving the full document data
      List<Map<String, dynamic>> customCategoriesData = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'] as String,
                'image_url': doc['image_url'] as String,
                'timestamp': doc['timestamp']
              })
          .toList();

      log('Fetched custom-categories from firebase: $customCategoriesData');

      // Return only category names, with default categories first
      return [
        ...defaultCategories,
        ...customCategoriesData.map((category) => category['name'])
      ];
    });
  }

  //! New method to get full category details with image
  Future<List<Map<String, dynamic>>> getCategoryDetails() async {
    // Fetch custom categories from Firestore
    QuerySnapshot snapshot = await _firestore
        .collection('custom_categories')
        .orderBy('timestamp', descending: true)
        .get();

    List<Map<String, dynamic>> customCategoriesData = snapshot.docs
        .map((doc) => {
              'id': doc.id,
              'name': doc['name'] as String,
              'image_url': doc['image_url'] as String,
              'timestamp': doc['timestamp']
            })
        .toList();

    // Define default category images
    Map<String, String> defaultCategoryImages = {
      'Equipments': 'assets/equipments.jpg',
      'Supplements': 'assets/suppliments.jpg',
      'Accessories': 'assets/accessories.jpeg',
      'Apparels': 'assets/apparels.jpeg',
    };

    // Combine with default categories
    List<Map<String, dynamic>> allCategories = [
      ...defaultCategories.map((name) => {
            'id': name.toLowerCase(),
            'name': name,
            'image_url': defaultCategoryImages[name] ?? '',
            'timestamp': null
          }),
      ...customCategoriesData
    ];

    return allCategories;
  }

  //! EDIT CATEGORY SERVICES
  Future<void> editCategory(
      String categoryId, String newCategoryName, File? newImageFile) async {
    try {
      // Check if new name is a default category name
      if (defaultCategories.contains(newCategoryName)) {
        throw Exception('Cannot rename to default category name');
      }

      // Get the existing category document
      DocumentSnapshot oldDoc = await _firestore
          .collection('custom_categories')
          .doc(categoryId)
          .get();

      if (!oldDoc.exists) {
        throw Exception('Category not found');
      }

      final String oldCategoryName = oldDoc.get('name');

      // prepare update data for category
      Map<String, dynamic> updateData = {
        'name': newCategoryName,
        'timestamp': FieldValue.serverTimestamp()
      };

      // If no new image is provided, keep the existing image URL
      if (newImageFile == null) {
        updateData['image_url'] = oldDoc.get('image_url');
      }

      // Handle image upload if a new image is provided
      if (newImageFile != null) {
        // Delete old image from firebase storage
        if (oldDoc.get('image_url') != null) {
          try {
            await _fireStorage.refFromURL(oldDoc.get('image_url')).delete();
          } catch (error) {
            log('Error deleting old category image: $error');
          }
        }

        // Upload new image
        final storageRef =
            _fireStorage.ref().child('category_images/$newCategoryName');
        final uploadTask = await storageRef.putFile(newImageFile);
        final imageUrl = await uploadTask.ref.getDownloadURL();

        updateData['image_url'] = imageUrl;
      }

      // Start a batch write
      final batch = _firestore.batch();

      // Update the category document
      batch.update(_firestore.collection('custom_categories').doc(categoryId),
          updateData);

      // Get all products with the old category name
      final productsSnapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: oldCategoryName)
          .get();

      // Update each product's category field
      for (var doc in productsSnapshot.docs) {
        batch.update(doc.reference, {'category': newCategoryName});
      }

      // Commit all updates in a single batch
      await batch.commit();

      log('SERVICES: CATEGORY AND ${productsSnapshot.docs.length} PRODUCTS UPDATED');
    } catch (error) {
      log('SERVICES: CATEGORY UPDATE FAILED $error');
      throw Exception('Failed to edit category: $error');
    }
  }

  //! DELETE CATEGORY SERVICES (DELETE CATEGORY AND PRODUCTS UNDER THE CATEGORY)
  Future<void> deleteCategory(String categoryId) async {
    try {
      // Get the category document to retrieve name and image URL before deletion
      final categoryDoc = await _firestore
          .collection('custom_categories')
          .doc(categoryId)
          .get();

      if (!categoryDoc.exists) {
        throw Exception('Category not found');
      }

      final categoryName = categoryDoc.data()?['name'];
      final imageUrl = categoryDoc.data()?['image_url'];

      // Delete all products with this category
      final productsSnapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: categoryName)
          .get();

      // Batch delete for products and their images
      final batch = _firestore.batch();

      // Keep track of all product image URLs that need to be deleted
      final List<String> productImageUrls = [];

      // Add each product deletion to batch and collect image URLs
      for (var doc in productsSnapshot.docs) {
        batch.delete(doc.reference);

        // Get image URLs from the product
        final List<String> images =
            List<String>.from(doc.data()['imageUrls'] ?? []);
        productImageUrls.addAll(images);
      }

      // Execute the batch delete
      await batch.commit();

      // Delete all product images from storage
      for (String url in productImageUrls) {
        try {
          await _fireStorage.refFromURL(url).delete();
        } catch (imageError) {
          log('Error deleting product image: $imageError');
          // Continue with other deletions even if one fails
        }
      }

      // Delete category image from Firebase Storage if it exists
      if (imageUrl != null) {
        try {
          await _fireStorage.refFromURL(imageUrl).delete();
        } catch (imageError) {
          log('Error deleting category image: $imageError');
        }
      }

      // Finally delete the category document
      await _firestore.collection('custom_categories').doc(categoryId).delete();

      log('SERVICES: CATEGORY AND ASSOCIATED PRODUCTS DELETED');
      log('Deleted ${productsSnapshot.docs.length} products');
    } catch (error) {
      log('SERVICES: CATEGORY DELETION ERROR $error');
      throw Exception('Failed to delete category: $error');
    }
  }
}
