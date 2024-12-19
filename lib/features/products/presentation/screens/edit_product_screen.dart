import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/categories/bloc/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/features/products/bloc/product_bloc/product_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_add_fields_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_edit_image_picker_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';
import 'package:wulflex_admin/shared/widgets/custom_weightandsize_selector_container_widget.dart';

class ScreenEditProducts extends StatefulWidget {
  final String screenTitle;
  final String productId;
  final String brandName;
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
      required this.brandName,
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
  final TextEditingController _brandNameController = TextEditingController();

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
    _brandNameController.text = widget.brandName;
    _nameController.text = widget.productName;
    _descriptionController.text = widget.productDescription;
    _selectedCategory = widget.productCategory;
    selectedWeights = widget.productWeight.toSet();
    selectedSizes = widget.productSize.toSet();
    _retailPriceController.text = widget.productRetailPrice.toString();
    _offerPriceController.text = widget.productOfferPrice.toString();
    isOnSale = widget.productIsOnSale;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _brandNameController.dispose();
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
            Navigator.pop(context);
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
                            style:
                                AppTextStyles.sideDrawerSelectedHeadingSmall),
                        SizedBox(height: 8),
                        Center(
                          child: CustomEditImagePickerWidget(
                              // delete individual selected images
                              onDeleteImage: (index) {
                                setState(() {
                                  selectedImages.removeAt(index);
                                });
                              },
                              onTap: () {
                                context
                                    .read<ProductBloc>()
                                    .add(PickImagesEvent());
                              },
                              imagePaths: selectedImages.isEmpty
                                  ? widget.existingImageUrls
                                  : selectedImages),
                        ),
                        Visibility(
                            visible: selectedImages.isNotEmpty,
                            child: SizedBox(height: 16)),
                        Visibility(
                          visible: selectedImages.isNotEmpty,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImages = [];
                              });
                            },
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
                                        style: AppTextStyles.bodySmall.copyWith(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                            visible: selectedImages.isNotEmpty,
                            child: SizedBox(height: 10)),
                        Visibility(
                            visible: selectedImages.isEmpty,
                            child: SizedBox(height: 25)),
                        Text('Brand Name',
                            style:
                                AppTextStyles.sideDrawerSelectedHeadingSmall),
                        SizedBox(height: 8),
                        CustomAddFieldsWidget(
                          maxLength: 20,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a brand name';
                            }
                            return null;
                          },
                          controller: _brandNameController,
                        ),
                        SizedBox(height: 25),
                        Text('Item Name',
                            style:
                                AppTextStyles.sideDrawerSelectedHeadingSmall),
                        SizedBox(height: 8),
                        CustomAddFieldsWidget(
                          maxLength: 60,
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
                            style:
                                AppTextStyles.sideDrawerSelectedHeadingSmall),
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
                            style:
                                AppTextStyles.sideDrawerSelectedHeadingSmall),
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
                        Visibility(
                            visible: selectedSizes.isEmpty,
                            child: SizedBox(height: 20)),
                        // Weight
                        Visibility(
                          visible: selectedSizes.isEmpty,
                          child: Text('Pick available Weight',
                              style:
                                  AppTextStyles.sideDrawerSelectedHeadingSmall),
                        ),
                        Visibility(
                            visible: selectedSizes.isEmpty,
                            child: SizedBox(height: 8)),
                        Visibility(
                          visible: selectedSizes.isEmpty,
                          child: Row(
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
                        ),
                        Visibility(
                            visible: selectedWeights.isEmpty,
                            child: SizedBox(height: 25)),

                        // Sizes
                        Visibility(
                          visible: selectedWeights.isEmpty,
                          child: Text('Pick available sizes',
                              style:
                                  AppTextStyles.sideDrawerSelectedHeadingSmall),
                        ),
                        Visibility(
                            visible: selectedWeights.isEmpty,
                            child: SizedBox(height: 8)),
                        Visibility(
                          visible: selectedWeights.isEmpty,
                          child: Row(
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
                        ),
                        SizedBox(height: 25),
                        Text('Item Retail Price (₹)',
                            style:
                                AppTextStyles.sideDrawerSelectedHeadingSmall),
                        SizedBox(height: 8),
                        CustomAddFieldsWidget(
                          maxLength: 7,
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
                            style:
                                AppTextStyles.sideDrawerSelectedHeadingSmall),
                        SizedBox(height: 8),
                        CustomAddFieldsWidget(
                          maxLength: 7,
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
                            style:
                                AppTextStyles.sideDrawerSelectedHeadingSmall),
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
                                    brandName: _brandNameController.text.trim(),
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
