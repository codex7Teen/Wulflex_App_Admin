import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/categories/bloc/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/features/products/bloc/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/features/products/presentation/widgets/add_product_screen_widgets.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';

class ScreenAddProducts extends StatefulWidget {
  final String screenTitle;
  const ScreenAddProducts({super.key, required this.screenTitle});

  @override
  State<ScreenAddProducts> createState() => ScreenAddProductsState();
}

class ScreenAddProductsState extends State<ScreenAddProducts> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _retailPriceController = TextEditingController();
  final TextEditingController _offerPriceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();

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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _retailPriceController.dispose();
    _offerPriceController.dispose();
    _brandController.dispose();
  }

  void _clearAllFields() {
    setState(() {
      // Reset form validation state
      formKey.currentState?.reset();
      // Clear text controllers
      _brandController.clear();
      _nameController.clear();
      _descriptionController.clear();
      _retailPriceController.clear();
      _offerPriceController.clear();
      // Clear selections
      _selectedCategory = null;
      selectedWeights.clear();
      selectedSizes.clear();
      selectedImages.clear();
      isOnSale = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWithbackbuttonWidget(appBarTitle: widget.screenTitle),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ImagePickError) {
            CustomSnackbar.showCustomSnackBar(
              context,
              state.message,
              icon: Icons.error_outline_rounded,
            );
          } else if (state is ProductAddSuccess) {
            CustomSnackbar.showCustomSnackBar(
              context,
              'Product added successfully... 🎉🎉🎉',
              icon: Icons.check_circle_outline_rounded,
            );
            // clears all the fields
            _clearAllFields();
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
                        AddProductScreenWidgets.buildUploadImageText(),
                        SizedBox(height: 8),
                        AddProductScreenWidgets.buildImagePickerContainer(
                            selectedImages, context, onDeleteImage: (index) {
                          setState(() {
                            selectedImages.removeAt(index);
                          });
                        }),
                        Visibility(
                            visible: selectedImages.isNotEmpty,
                            child: SizedBox(height: 16)),
                        Visibility(
                          visible: selectedImages.isNotEmpty,
                          child: AddProductScreenWidgets.buildClearImagesButton(
                            onTap: () {
                              setState(() {
                                selectedImages = [];
                              });
                            },
                          ),
                        ),
                        Visibility(
                            visible: selectedImages.isNotEmpty,
                            child: SizedBox(height: 10)),
                        Visibility(
                            visible: selectedImages.isEmpty,
                            child: SizedBox(height: 25)),
                        AddProductScreenWidgets.buildItemBrandText(),
                        SizedBox(height: 8),
                        AddProductScreenWidgets.buildBrandField(
                            _brandController),
                        SizedBox(height: 25),
                        AddProductScreenWidgets.buildItemNameText(),
                        SizedBox(height: 8),
                        AddProductScreenWidgets.buildItemNameField(
                            _nameController),
                        SizedBox(height: 25),
                        AddProductScreenWidgets.buildItemDescriptionText(),
                        SizedBox(height: 8),
                        AddProductScreenWidgets.buildItemDescriptionField(
                            _descriptionController),
                        SizedBox(height: 25),
                        //! Category
                        AddProductScreenWidgets.buildItemCategoryText(),
                        SizedBox(height: 8),
                        AddProductScreenWidgets.buildCategorySelectionSection(
                            _selectedCategory, (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        }),
                        Visibility(
                            visible: selectedSizes.isEmpty,
                            child: SizedBox(height: 20)),
                        //! Weight
                        AddProductScreenWidgets.buildWeightText(selectedSizes),
                        Visibility(
                            visible: selectedSizes.isEmpty,
                            child: SizedBox(height: 8)),
                        AddProductScreenWidgets.buildWeightSelectors(
                            selectedSizes, selectedWeights, onFiveKgTapped: () {
                          setState(() {
                            if (selectedWeights.contains('5 KG')) {
                              selectedWeights.remove('5 KG');
                            } else {
                              selectedWeights.add('5 KG');
                            }
                          });
                        }, onTenKgTapped: () {
                          setState(() {
                            if (selectedWeights.contains('10 KG')) {
                              selectedWeights.remove('10 KG');
                            } else {
                              selectedWeights.add('10 KG');
                            }
                          });
                        }, onTwentyKgTapped: () {
                          setState(() {
                            if (selectedWeights.contains('20 KG')) {
                              selectedWeights.remove('20 KG');
                            } else {
                              selectedWeights.add('20 KG');
                            }
                          });
                        }, onThirtyKgTapped: () {
                          setState(() {
                            if (selectedWeights.contains('30 KG')) {
                              selectedWeights.remove('30 KG');
                            } else {
                              selectedWeights.add('30 KG');
                            }
                          });
                        }),
                        Visibility(
                            visible: selectedWeights.isEmpty,
                            child: SizedBox(height: 25)),

                        //! Sizes
                        AddProductScreenWidgets.buildSizedText(selectedWeights),
                        Visibility(
                            visible: selectedWeights.isEmpty,
                            child: SizedBox(height: 8)),
                        AddProductScreenWidgets.buildSizeSelectors(
                            selectedWeights, selectedSizes, onSTapped: () {
                          setState(() {
                            if (selectedSizes.contains('S')) {
                              selectedSizes.remove('S');
                            } else {
                              selectedSizes.add('S');
                            }
                          });
                        }, onMTapped: () {
                          setState(() {
                            if (selectedSizes.contains('M')) {
                              selectedSizes.remove('M');
                            } else {
                              selectedSizes.add('M');
                            }
                          });
                        }, onLTapped: () {
                          setState(() {
                            if (selectedSizes.contains('L')) {
                              selectedSizes.remove('L');
                            } else {
                              selectedSizes.add('L');
                            }
                          });
                        }, onXLTapped: () {
                          setState(() {
                            if (selectedSizes.contains('XL')) {
                              selectedSizes.remove('XL');
                            } else {
                              selectedSizes.add('XL');
                            }
                          });
                        }),
                        SizedBox(height: 25),
                        AddProductScreenWidgets.buildRetailPriceText(),
                        SizedBox(height: 8),
                        AddProductScreenWidgets.buildRetailPriceField(
                            _retailPriceController),
                        SizedBox(height: 25),
                        AddProductScreenWidgets.buildOfferpriceText(),
                        SizedBox(height: 8),
                        AddProductScreenWidgets.buildOfferpriceField(
                            _offerPriceController),
                        SizedBox(height: 25),
                        AddProductScreenWidgets.buildSaleText(),
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
                              selectedImages.isEmpty) {
                            CustomSnackbar.showCustomSnackBar(
                                context, "Please upload an image",
                                icon: Icons.error_outline_rounded);
                            return;
                          } else if (formKey.currentState!.validate() &&
                              selectedWeights.isEmpty &&
                              selectedSizes.isEmpty) {
                            CustomSnackbar.showCustomSnackBar(
                                context, "Please select a weight or size",
                                icon: Icons.error_outline_rounded);
                            return;
                          } else if (formKey.currentState!.validate() &&
                              _selectedCategory == null) {
                            CustomSnackbar.showCustomSnackBar(
                                context, "Please select a category",
                                icon: Icons.error_outline_rounded);
                            return;
                          }

                          //! Add product to fbase
                          context.read<ProductBloc>().add(
                                AddProductEvent(
                                  brandName: _brandController.text.trim(),
                                  name: _nameController.text.trim(),
                                  description:
                                      _descriptionController.text.trim(),
                                  category: _selectedCategory!,
                                  images: selectedImages
                                      .map((path) => File(path))
                                      .toList(),
                                  weights: selectedWeights,
                                  sizes: selectedSizes,
                                  retailPrice:
                                      double.parse(_retailPriceController.text),
                                  offerPrice:
                                      double.parse(_offerPriceController.text),
                                  isOnSale: isOnSale,
                                ),
                              );
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
              if (state is ProductLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
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
