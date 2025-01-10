import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';

class AddEditCategoryScreenWidgets {
  static Widget buildUploadImageText() {
    return Text('Upload Image',
        style: AppTextStyles.sideDrawerSelectedHeadingSmall);
  }

  static Widget buildImagePickerArea({
    required VoidCallback onTap,
    File? selectedImage,
    String? existingImageUrl,
  }) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: selectedImage != null ? 120 : 75,
          width: selectedImage != null ? 120 : 75,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _buildImageDisplay(selectedImage, existingImageUrl),
          ),
        ),
      ),
    );
  }

  static Widget _buildImageDisplay(
      File? selectedImage, String? existingImageUrl) {
    if (selectedImage != null) {
      return Image.file(selectedImage, fit: BoxFit.cover);
    } else if (existingImageUrl != null) {
      return existingImageUrl.startsWith('assets/')
          ? Image.asset(existingImageUrl, fit: BoxFit.cover)
          : Image.network(existingImageUrl, fit: BoxFit.cover);
    } else {
      return Image.asset(
        'assets/Add Image.png',
        fit: BoxFit.cover,
        color: AppColors.blueThemeColor,
      );
    }
  }

  static Widget buildCategoryNameField() {
    return Text('Category Name',
        style: AppTextStyles.sideDrawerSelectedHeadingSmall);
  }

  static const double defaultSpacing = 8.0;
  static const double largeSpacing = 25.0;
}
