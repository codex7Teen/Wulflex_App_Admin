import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wulflex_admin/models/product_model.dart';
import 'package:wulflex_admin/services/product_services.dart';
import 'package:wulflex_admin/utils/consts/app_colors.dart';
import 'package:wulflex_admin/utils/consts/text_styles.dart';
import 'package:wulflex_admin/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/widgets/custom_add_fields_widget.dart';
import 'package:wulflex_admin/widgets/custom_image_picker_container_widget.dart';
import 'package:wulflex_admin/widgets/custom_snacbar.dart';
import 'package:wulflex_admin/widgets/custom_weightandsize_selector_container_widget.dart';

class ScreenAddProducts extends StatefulWidget {
  final String screenTitle;
  const ScreenAddProducts({super.key, required this.screenTitle});

  @override
  State<ScreenAddProducts> createState() => _ScreenAddEquipmentsState();
}

class _ScreenAddEquipmentsState extends State<ScreenAddProducts> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  final TextEditingController _offerPriceController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    'Equipments',
    'Supplements',
    'Accessories',
    'Apparels',
    'Clothing'
  ];

  // Track selected weights
  Set<String> selectedWeights = {};

  // Track selected sizes
  Set<String> selectedSizes = {};

  // List to store picked image path
  List<String> selectedImages = [];

  // Checkbox State
  bool isOnSale = false;

  Future pickImages() async {
    // Open image picker
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);

    // Check if images are selected
    if (images.length <= 4) {
      setState(() {
        // Clear the previously selected images
        selectedImages.clear();
        // Add the selected images' paths to the list
        selectedImages.addAll(images.map((image) => image.path));
      });
    } else {
      // Show a message if more than four images are selected
      if (mounted) {
        CustomSnackbar.showCustomSnackBar(
            context, 'You can only select upto 4 images!',
            icon: Icons.error_outline_rounded, applyErrorIconColor: true);
      }
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upload Image', style: AppTextStyles.headLineMediumSmall),
                SizedBox(height: 8),
                Center(
                  child: CustomImagePickerContainerWidget(
                      onTap: pickImages, imagePaths: selectedImages),
                ),
                SizedBox(height: 25),
                Text('Item Name', style: AppTextStyles.headLineMediumSmall),
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
                Text('Item Category', style: AppTextStyles.headLineMediumSmall),
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightGreyThemeColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 3),
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            style: AppTextStyles.titleMedium
                                .copyWith(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        border: InputBorder.none, // Removes the default border
                      ),
                      style: AppTextStyles.titleMedium
                          .copyWith(color: Colors.black),
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.black), // Optional customization
                    ),
                  ),
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
                GestureDetector(
                    onTap: () async {
                      if (formKey.currentState!.validate() &&
                          selectedImages.isEmpty) {
                        CustomSnackbar.showCustomSnackBar(
                            context, "Please upload an image",
                            icon: Icons.error_outline_rounded);
                        return;
                      } else if (formKey.currentState!.validate() &&
                          selectedWeights.isEmpty) {
                        CustomSnackbar.showCustomSnackBar(
                            context, "Please select a weight",
                            icon: Icons.error_outline_rounded);
                        return;
                      } else if (formKey.currentState!.validate() &&
                          _selectedCategory == null) {
                        CustomSnackbar.showCustomSnackBar(
                            context, "Please select a category ",
                            icon: Icons.error_outline_rounded);
                        return;
                      }

                      // Create product model
                      try {
                        List<File> imageFiles =
                            selectedImages.map((path) => File(path)).toList();
                        final productServices = ProductServices();
                        List<String> imageUrls =
                            await productServices.uploadImages(imageFiles, _nameController.text.trim());

                        final newProduct = ProductModel(
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                            category: _selectedCategory!,
                            imageUrls: imageUrls,
                            weights: selectedWeights.toList(),
                            sizes: selectedSizes.toList(),
                            retailPrice: double.parse(
                                _retailPriceController.text.trim()),
                            offerPrice:
                                double.parse(_offerPriceController.text.trim()),
                            isOnSale: isOnSale);

                            await productServices.addProduct(newProduct, _nameController.text.trim());
                      } catch (error) {
                        CustomSnackbar.showCustomSnackBar(
                            context, "Failed to add product: $error",
                            icon: Icons.error_outline_rounded);
                      }
                    },
                    child: BlueButtonWidget(buttonText: 'Add Item'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
