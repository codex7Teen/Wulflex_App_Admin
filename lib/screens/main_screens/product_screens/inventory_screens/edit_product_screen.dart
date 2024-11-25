import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/blocs/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/blocs/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/utils/consts/app_colors.dart';
import 'package:wulflex_admin/utils/consts/text_styles.dart';
import 'package:wulflex_admin/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/widgets/custom_add_fields_widget.dart';
import 'package:wulflex_admin/widgets/custom_edit_image_picker_widget.dart';
import 'package:wulflex_admin/widgets/custom_image_picker_container_widget.dart';
import 'package:wulflex_admin/widgets/custom_snacbar.dart';
import 'package:wulflex_admin/widgets/custom_weightandsize_selector_container_widget.dart';

class ScreenEditProducts extends StatefulWidget {
  final String screenTitle;
  final String productId;
  final String productName;
  final String productDescription;
  final String productCategory;
  final List<String> productWeight;
  final List<String> productSize;
  final double productRetailPrice;
  final double productOfferPrice;
  final bool productIsOnSale;
  final List<String> existingImageUrls;
  const ScreenEditProducts(
      {super.key,
      required this.screenTitle,
      required this.productId,
      required this.productName,
      required this.productDescription,
      required this.productCategory,
      required this.productWeight,
      required this.productSize,
      required this.productRetailPrice,
      required this.productOfferPrice,
      required this.productIsOnSale,
      required this.existingImageUrls});

  @override
  State<ScreenEditProducts> createState() => ScreenEditProductsState();
}

class ScreenEditProductsState extends State<ScreenEditProducts> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  final TextEditingController _offerPriceController = TextEditingController();

  // To store the selected category
  String? _selectedCategory;
  // Track selected weights
  Set<String> selectedWeights = {};
  // Track selected sizes
  Set<String> selectedSizes = {};
  // List to store picked image path
  List<String> selectedImages = [];
  // Checkbox State
  bool isOnSale = false;

  @override
  void initState() {
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
    _nameController.text = widget.productName;
    _descriptionController.text = widget.productDescription;
    _selectedCategory = widget.productCategory;
    selectedWeights = widget.productWeight.toSet();
    selectedSizes = widget.productSize.toSet();
    _retailPriceController.text = widget.productRetailPrice.toString();
    _offerPriceController.text = widget.productOfferPrice.toString();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _retailPriceController.dispose();
    _offerPriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWithbackbuttonWidget(appBarTitle: widget.screenTitle),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            CustomSnackbar.showCustomSnackBar(
              context,
              state.message,
              icon: Icons.error_outline_rounded,
            );
          } else if (state is ProductUpdateSuccess) {
            CustomSnackbar.showCustomSnackBar(
              context,
              'Product updated successfully... 🎉🎉🎉',
              icon: Icons.check_circle_outline_rounded,
            );
          } else if (state is ImagesPickedSuccess) {
            setState(() {
              selectedImages = state.imagePaths;
            });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Upload Image',
                            style: AppTextStyles.headLineMediumSmall),
                        SizedBox(height: 8),
                        Center(
                          child: CustomEditImagePickerWidget(
                              onTap: () {
                                context
                                    .read<ProductBloc>()
                                    .add(PickImagesEvent());
                              },
                              imagePaths: selectedImages.isEmpty
                                  ? widget.existingImageUrls
                                  : selectedImages),
                        ),
                        SizedBox(height: 25),
                        Text('Item Name',
                            style: AppTextStyles.headLineMediumSmall),
                        SizedBox(height: 8),
                        CustomAddFieldsWidget(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an item name';
                            }
                            return null;
                          },
                          controller: _nameController,
                        ),
                        SizedBox(height: 25),
                        Text('Item Description',
                            style: AppTextStyles.headLineMediumSmall),
                        SizedBox(height: 8),
                        CustomAddFieldsWidget(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter an item description';
                              }
                              return null;
                            },
                            controller: _descriptionController,
                            textInputType: TextInputType.multiline,
                            minLines: 4),
                        SizedBox(height: 25),
                        //! Category
                        Text('Item Category',
                            style: AppTextStyles.headLineMediumSmall),
                        SizedBox(height: 8),
                        Row(
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
                                      defaultCategories =
                                          state.defaultCategories;
                                      customCategories = state.customCategories;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedCategory,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedCategory = value!;
                                          });
                                        },
                                        items: [
                                          // Show default categories
                                          ...defaultCategories.map((category) {
                                            return DropdownMenuItem(
                                              value: category,
                                              child: Text(
                                                category,
                                                style: AppTextStyles.titleMedium
                                                    .copyWith(
                                                        color: Colors.black),
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
                                                      color:
                                                          Colors.grey.shade300,
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
                                                    .copyWith(
                                                        color: Colors.black),
                                              ),
                                            );
                                          }),
                                        ],
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Select Category',
                                          hintStyle: AppTextStyles.titleMedium
                                              .copyWith(
                                            color: Colors.grey[
                                                600], // Made hint text darker
                                            fontSize: 16, // Increased font size
                                          ),
                                          fillColor: Colors.transparent,
                                        ),
                                        style:
                                            AppTextStyles.titleMedium.copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.grey[600]),
                                        isExpanded: true,
                                        hint: Text(
                                          'Select Category',
                                          style: AppTextStyles.titleMedium
                                              .copyWith(
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
                        ),
                        SizedBox(height: 20),
                        // Weight
                        Text('Pick available Weight',
                            style: AppTextStyles.headLineMediumSmall),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            CustomWeightandsizeSelectorContainerWidget(
                                weightOrSize: '5 KG',
                                isSelected: selectedWeights.contains('5 KG'),
                                onTap: () {
                                  setState(() {
                                    if (selectedWeights.contains('5 KG')) {
                                      selectedWeights.remove('5 KG');
                                    } else {
                                      selectedWeights.add('5 KG');
                                    }
                                  });
                                }),
                            SizedBox(width: 8),
                            CustomWeightandsizeSelectorContainerWidget(
                                weightOrSize: '10 KG',
                                isSelected: selectedWeights.contains('10 KG'),
                                onTap: () {
                                  setState(() {
                                    if (selectedWeights.contains('10 KG')) {
                                      selectedWeights.remove('10 KG');
                                    } else {
                                      selectedWeights.add('10 KG');
                                    }
                                  });
                                }),
                            SizedBox(width: 8),
                            CustomWeightandsizeSelectorContainerWidget(
                                weightOrSize: '20 KG',
                                isSelected: selectedWeights.contains('20 KG'),
                                onTap: () {
                                  setState(() {
                                    if (selectedWeights.contains('20 KG')) {
                                      selectedWeights.remove('20 KG');
                                    } else {
                                      selectedWeights.add('20 KG');
                                    }
                                  });
                                }),
                            SizedBox(width: 8),
                            CustomWeightandsizeSelectorContainerWidget(
                                weightOrSize: '30 KG',
                                isSelected: selectedWeights.contains('30 KG'),
                                onTap: () {
                                  setState(() {
                                    if (selectedWeights.contains('30 KG')) {
                                      selectedWeights.remove('30 KG');
                                    } else {
                                      selectedWeights.add('30 KG');
                                    }
                                  });
                                }),
                          ],
                        ),
                        SizedBox(height: 25),

                        // Sizes
                        Text('Pick available sizes',
                            style: AppTextStyles.headLineMediumSmall),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            CustomWeightandsizeSelectorContainerWidget(
                                weightOrSize: 'S',
                                isSelected: selectedSizes.contains('S'),
                                onTap: () {
                                  setState(() {
                                    if (selectedSizes.contains('S')) {
                                      selectedSizes.remove('S');
                                    } else {
                                      selectedSizes.add('S');
                                    }
                                  });
                                }),
                            SizedBox(width: 8),
                            CustomWeightandsizeSelectorContainerWidget(
                                weightOrSize: 'M',
                                isSelected: selectedSizes.contains('M'),
                                onTap: () {
                                  setState(() {
                                    if (selectedSizes.contains('M')) {
                                      selectedSizes.remove('M');
                                    } else {
                                      selectedSizes.add('M');
                                    }
                                  });
                                }),
                            SizedBox(width: 8),
                            CustomWeightandsizeSelectorContainerWidget(
                                weightOrSize: 'L',
                                isSelected: selectedSizes.contains('L'),
                                onTap: () {
                                  setState(() {
                                    if (selectedSizes.contains('L')) {
                                      selectedSizes.remove('L');
                                    } else {
                                      selectedSizes.add('L');
                                    }
                                  });
                                }),
                            SizedBox(width: 8),
                            CustomWeightandsizeSelectorContainerWidget(
                                weightOrSize: 'XL',
                                isSelected: selectedSizes.contains('XL'),
                                onTap: () {
                                  setState(() {
                                    if (selectedSizes.contains('XL')) {
                                      selectedSizes.remove('XL');
                                    } else {
                                      selectedSizes.add('XL');
                                    }
                                  });
                                }),
                          ],
                        ),
                        SizedBox(height: 25),
                        Text('Item Retail Price (₹)',
                            style: AppTextStyles.headLineMediumSmall),
                        SizedBox(height: 8),
                        CustomAddFieldsWidget(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter item retail price';
                            }
                            return null;
                          },
                          controller: _retailPriceController,
                          textInputType: TextInputType.number,
                        ),
                        SizedBox(height: 25),
                        Text('Item Offer Price (₹)',
                            style: AppTextStyles.headLineMediumSmall),
                        SizedBox(height: 8),
                        CustomAddFieldsWidget(
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter item offer price';
                            }
                            return null;
                          },
                          controller: _offerPriceController,
                          textInputType: TextInputType.number,
                        ),
                        SizedBox(height: 25),
                        Text('ADD ITEM TO SALE SECTION',
                            style: AppTextStyles.headLineMediumSmall),
                        SizedBox(height: 8),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                              value: isOnSale,
                              onChanged: (value) => setState(() {
                                    isOnSale = value ?? false;
                                  })),
                        ),
                        SizedBox(height: 25),
                        GestureDetector(onTap: () async {
                          if (formKey.currentState!.validate() &&
                              selectedWeights.isEmpty &&
                              selectedSizes.isEmpty) {
                            CustomSnackbar.showCustomSnackBar(
                                context, "Please select a weight or size",
                                icon: Icons.error_outline_rounded);
                            return;
                          } else if (formKey.currentState!.validate() &&
                              _selectedCategory == null) {
                            CustomSnackbar.showCustomSnackBar(
                                context, "Please select a category ",
                                icon: Icons.error_outline_rounded);
                            return;
                          }
                          if (formKey.currentState!.validate()) {
                            // Dispatch update event
                            context.read<ProductBloc>().add(
                                  UpdateProductEvent(
                                    productId: widget.productId,
                                    name: _nameController.text.trim(),
                                    description:
                                        _descriptionController.text.trim(),
                                    category: _selectedCategory!,
                                    existingImageUrls: selectedImages.isEmpty
                                        ? widget.existingImageUrls
                                        : [],
                                    newImagePaths: selectedImages.isNotEmpty
                                        ? selectedImages
                                        : null,
                                    weights: selectedWeights,
                                    sizes: selectedSizes,
                                    retailPrice: double.parse(
                                        _retailPriceController.text.trim()),
                                    offerPrice: double.parse(
                                        _offerPriceController.text.trim()),
                                    isOnSale: isOnSale,
                                  ),
                                );
                          }

                          //! Add product to fbase
                        }, child: BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            return BlueButtonWidget(
                              buttonText: 'Add Item',
                              isLoading: state is ProductLoading,
                            );
                          },
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              //! Show loading when product is uploading
              if (state is ProductLoading && selectedImages.isNotEmpty)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.blueThemeColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Uploading Product...',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
