import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryServices {
  final _firestore = FirebaseFirestore.instance;

  // Default categories that should always appear
  static const List<String> defaultCategories = [
    'Equipments',
    'Supplements',
    'Accessories',
    'Apparels',
    'Clothing'
  ];

  //! Add a new category
  Future<void> addCategory(String categoryName) async {
    try {
      // Check if category already exists in defaults
      if (defaultCategories.contains(categoryName)) {
        throw Exception('This category already exists in default categories');
      }
      await _firestore.collection('custom_categories').add({
        'name': categoryName,
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
      // Get custom categories from Firebase
      List<String> customCategories =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      log('Fetched custom-categories from firebase: $customCategories');
      // Combine default and custom categories
      // Using Set to remove any duplicates
      return {...defaultCategories, ...customCategories}.toList();
    });
  }
}
