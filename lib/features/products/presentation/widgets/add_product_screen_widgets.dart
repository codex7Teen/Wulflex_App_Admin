import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/features/categories/bloc/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/features/products/bloc/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/shared/widgets/custom_add_fields_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_image_picker_container_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_weightandsize_selector_container_widget.dart';

class AddProductScreenWidgets {
  static Widget buildUploadImageText() {
    return Text('Upload Image',
        style: AppTextStyles.sideDrawerSelectedHeadingSmall);
  }

  static Widget buildImagePickerContainer(
      List<String> selectedImages, BuildContext context,
      {dynamic Function(int)? onDeleteImage}) {
    return Center(
      child: CustomImagePickerContainerWidget(
          // delte individual images
          onDeleteImage: onDeleteImage,
          onTap: () {
            context.read<ProductBloc>().add(PickImagesEvent());
          },
          imagePaths: selectedImages),
    );
  }

  static Widget buildClearImagesButton({void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: 150,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppColors.blueThemeColor,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.clear,
                size: 17,
                color: AppColors.whiteThemeColor,
              ),
              SizedBox(width: 3),
              Text('CLEAR IMAGES',
                  style: AppTextStyles.bodySmall
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildItemBrandText() {
    return Text('Item Brand',
        style: AppTextStyles.sideDrawerSelectedHeadingSmall);
  }

  static Widget buildBrandField(TextEditingController brandController) {
    return CustomAddFieldsWidget(
      maxLength: 20,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a brand name';
        }
        return null;
      },
      controller: brandController,
    );
  }

  static Widget buildItemNameText() {
    return Text('Item Name',
        style: AppTextStyles.sideDrawerSelectedHeadingSmall);
  }

  static Widget buildItemNameField(TextEditingController nameController) {
    return CustomAddFieldsWidget(
      maxLength: 60,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an item name';
        }
        return null;
      },
      controller: nameController,
    );
  }

  static Widget buildItemDescriptionText() {
    return Text('Item Description',
        style: AppTextStyles.sideDrawerSelectedHeadingSmall);
  }

  static Widget buildItemDescriptionField(
      TextEditingController descriptionController) {
    return CustomAddFieldsWidget(
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter an item description';
          }
          return null;
        },
        controller: descriptionController,
        textInputType: TextInputType.multiline,
        minLines: 4);
  }

  static Widget buildItemCategoryText() {
    return Text('Item Category',
        style: AppTextStyles.sideDrawerSelectedHeadingSmall);
  }

  static Widget buildCategorySelectionSection(
      String? selectedCategory, ValueChanged onChanged) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.lightGreyThemeColor,
            ),
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                log('Current category bloc state: $state');
                List<String> defaultCategories = [];
                List<String> customCategories = [];

                if (state is CategoriesLoaded) {
                  defaultCategories = state.defaultCategories;
                  customCategories = state.customCategories;
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: onChanged,
                    items: [
                      // Show default categories
                      ...defaultCategories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            style: AppTextStyles.titleMedium
                                .copyWith(color: Colors.black),
                          ),
                        );
                      }),
                      // divider if there are custom categories
                      if (customCategories.isNotEmpty)
                        DropdownMenuItem<String>(
                          enabled: false,
                          value: null,
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      // Show custom categories
                      ...customCategories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            style: AppTextStyles.titleMedium
                                .copyWith(color: Colors.black),
                          ),
                        );
                      }),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Select Category',
                      hintStyle: AppTextStyles.titleMedium.copyWith(
                        color: Colors.grey[600], // Made hint text darker
                        fontSize: 16, // Increased font size
                      ),
                      fillColor: Colors.transparent,
                    ),
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    isExpanded: true,
                    hint: Text(
                      'Select Category',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  static Widget buildWeightText(Set<String> selectedSizes) {
    return Visibility(
      visible: selectedSizes.isEmpty,
      child: Text('Pick available Weight',
          style: AppTextStyles.sideDrawerSelectedHeadingSmall),
    );
  }

  static Widget buildWeightSelectors(
      Set<String> selectedSizes, Set<String> selectedWeights,
      {required VoidCallback onFiveKgTapped,
      required VoidCallback onTenKgTapped,
      required VoidCallback onTwentyKgTapped,
      required VoidCallback onThirtyKgTapped}) {
    return Visibility(
      visible: selectedSizes.isEmpty,
      child: Row(
        children: [
          CustomWeightandsizeSelectorContainerWidget(
              weightOrSize: '5 KG',
              isSelected: selectedWeights.contains('5 KG'),
              onTap: onFiveKgTapped),
          SizedBox(width: 8),
          CustomWeightandsizeSelectorContainerWidget(
              weightOrSize: '10 KG',
              isSelected: selectedWeights.contains('10 KG'),
              onTap: onTenKgTapped),
          SizedBox(width: 8),
          CustomWeightandsizeSelectorContainerWidget(
              weightOrSize: '20 KG',
              isSelected: selectedWeights.contains('20 KG'),
              onTap: onTwentyKgTapped),
          SizedBox(width: 8),
          CustomWeightandsizeSelectorContainerWidget(
              weightOrSize: '30 KG',
              isSelected: selectedWeights.contains('30 KG'),
              onTap: onThirtyKgTapped),
        ],
      ),
    );
  }

  static Widget buildSizedText(Set<String> selectedWeights) {
    return Visibility(
      visible: selectedWeights.isEmpty,
      child: Text('Pick available sizes',
          style: AppTextStyles.sideDrawerSelectedHeadingSmall),
    );
  }

  static Widget buildSizeSelectors(
      Set<String> selectedWeights, Set<String> selectedSizes,
      {required VoidCallback onSTapped,
      required VoidCallback onMTapped,
      required VoidCallback onLTapped,
      required VoidCallback onXLTapped}) {
    return Visibility(
      visible: selectedWeights.isEmpty,
      child: Row(
        children: [
          CustomWeightandsizeSelectorContainerWidget(
              weightOrSize: 'S',
              isSelected: selectedSizes.contains('S'),
              onTap: onSTapped),
          SizedBox(width: 8),
          CustomWeightandsizeSelectorContainerWidget(
              weightOrSize: 'M',
              isSelected: selectedSizes.contains('M'),
              onTap: onMTapped),
          SizedBox(width: 8),
          CustomWeightandsizeSelectorContainerWidget(
              weightOrSize: 'L',
              isSelected: selectedSizes.contains('L'),
              onTap: onLTapped),
          SizedBox(width: 8),
          CustomWeightandsizeSelectorContainerWidget(
              weightOrSize: 'XL',
              isSelected: selectedSizes.contains('XL'),
              onTap: onXLTapped),
        ],
      ),
    );
  }

  static Widget buildRetailPriceText() {
    return Text('Item Retail Price (₹)',
        style: AppTextStyles.sideDrawerSelectedHeadingSmall);
  }

  static Widget buildRetailPriceField(
      TextEditingController retailPriceController) {
    return CustomAddFieldsWidget(
      maxLength: 7,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter item retail price';
        }
        return null;
      },
      controller: retailPriceController,
      textInputType: TextInputType.number,
    );
  }

  static Widget buildOfferpriceText() {
    return Text('Item Offer Price (₹)',
        style: AppTextStyles.sideDrawerSelectedHeadingSmall);
  }

  static Widget buildOfferpriceField(
      TextEditingController offerPriceController) {
    return CustomAddFieldsWidget(
      maxLength: 7,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter item offer price';
        }
        return null;
      },
      controller: offerPriceController,
      textInputType: TextInputType.number,
    );
  }

  static Widget buildSaleText() {
    return Text('ADD ITEM TO SALE SECTION',
        style: AppTextStyles.sideDrawerSelectedHeadingSmall);
  }
}
