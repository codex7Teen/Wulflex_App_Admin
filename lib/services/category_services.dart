import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wulflex_admin/utils/consts/app_constants.dart';

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
    // prevent taking default category name
    if (defaultCategories.contains(newCategoryName)) {
      throw Exception('Cannot rename to default categoryname');
    }

    // Get the existing document to retrieve the current image URL
    DocumentSnapshot oldDoc = await _firestore
        .collection('custom_categories')
        .doc(categoryId)
        .get();

    // prepare update data
    Map<String, dynamic> updateData = {
      'name': newCategoryName,
      'timeStamp': FieldValue.serverTimestamp()
    };

    // If no new image is provided, keep the existing image URL
    if (newImageFile == null && oldDoc.exists) {
      updateData['image_url'] = oldDoc.get('image_url');
    }

    // handle image upload if a new image is provided
    if (newImageFile != null) {
      // delete old image from firebase storage
      if (oldDoc.exists && oldDoc.get('image_url') != null) {
        await _fireStorage.refFromURL(oldDoc.get('image_url')).delete();
      }

      // upload new image
      final storageRef =
          _fireStorage.ref().child('category_images/$newCategoryName');
      final uploadTask = await storageRef.putFile(newImageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      updateData['image_url'] = imageUrl;
    }

    await _firestore
        .collection('custom_categories')
        .doc(categoryId)
        .update(updateData);

    log('SERVICES: CATEGORY UPDATED');
  } catch (error) {
    log('SERVICES: CATEGORY UPDATION FAILED $error');
    throw Exception('Failed to edit category: $error');
  }
}

  //! DELETE CATEGORY SERVICES
  Future<void> deleteCategory(String categoryId) async {
    try {
      // Get the document to retrieve image URL before deletion
      final doc = await _firestore
          .collection('custom_categories')
          .doc(categoryId)
          .get();

      // Delete image from Firebase Storage if it exists
      if (doc.exists && doc.data()?['image_url'] != null) {
        await _fireStorage.refFromURL(doc.data()!['image_url']).delete();
      }

      // Delete the category from Firestore
      await _firestore.collection('custom_categories').doc(categoryId).delete();
      log('SERVICES: CATEGORY DELETED');
    } catch (error) {
      log('SERVICES: CATEGORY DELETION ERROR $error');
      throw Exception('Failed to delete category: $error');
    }
  }
}
