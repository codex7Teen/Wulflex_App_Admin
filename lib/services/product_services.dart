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
        snapshot.docs.map((doc) => ProductModel.fromMap(doc.data())).toList());
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
        final downloadUrl = await snapShot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return downloadUrls;
    } catch (error) {
      throw Exception('Failed to upload images: $error');
    }
  }
}
