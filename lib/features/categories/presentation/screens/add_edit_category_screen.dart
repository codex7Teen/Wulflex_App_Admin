import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wulflex_admin/features/categories/bloc/category_bloc/category_bloc.dart';
import 'package:wulflex_admin/features/categories/presentation/widgets/add_edit_category_screen_widgets.dart';
import 'package:wulflex_admin/shared/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_add_fields_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';

class ScreenAddCategory extends StatefulWidget {
  final String screenTitle;
  final bool isEditMode;
  final Map<String, dynamic>? existingCategory;
  const ScreenAddCategory(
      {super.key,
      required this.screenTitle,
      this.isEditMode = false,
      this.existingCategory});

  @override
  State<ScreenAddCategory> createState() => _ScreenAddCategoryState();
}

class _ScreenAddCategoryState extends State<ScreenAddCategory> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If in editmode, prepopulate the fields
    if (widget.isEditMode && widget.existingCategory != null) {
      _categoryNameController.text = widget.existingCategory!['name'];
      // Handle existing image logic here
      _existingImageUrl = widget.existingCategory!['image_url'];
    }
  }

  @override
  void dispose() {
    super.dispose();
    _categoryNameController.dispose();
  }

  File? _selectedImage;
  String? _existingImageUrl;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWithbackbuttonWidget(
          appBarTitle:
              widget.isEditMode ? 'Edit Category' : widget.screenTitle),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            CustomSnackbar.showCustomSnackBar(
              appearFromTop: true,
              context,
              state.message,
              icon: Icons.error,
            );
          } else if (state is CategoryAddSuccess ||
              state is CategoryEditSuccess) {
            if (state is CategoryEditSuccess) {
              Navigator.pop(context);
            }
            CustomSnackbar.showCustomSnackBar(
              context,
              widget.isEditMode
                  ? 'Category updated successfully... 🎉🎉🎉'
                  : 'Category added successfully... 🎉🎉🎉',
              icon: Icons.check_circle_outline_rounded,
            );
            setState(() {
              setState(() {
                // Reset form validation state
                formKey.currentState?.reset();
                // Clear text controllers
                _categoryNameController.clear();
                // Clear the selected image
                _selectedImage = null;
                // clear existing image
                _existingImageUrl = null;
              });
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddEditCategoryScreenWidgets.buildUploadImageText(),
                    SizedBox(height: 8),
                    AddEditCategoryScreenWidgets.buildImagePickerArea(
                        onTap: _pickImage,
                        existingImageUrl: _existingImageUrl,
                        selectedImage: _selectedImage),
                    SizedBox(height: 25),
                    AddEditCategoryScreenWidgets.buildCategoryNameField(),
                    SizedBox(height: 8),
                    CustomAddFieldsWidget(
                      maxLength: 12,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a category name';
                        }
                        return null;
                      },
                      controller: _categoryNameController,
                    ),
                    SizedBox(height: 25),
                    GestureDetector(onTap: () async {
                      if (formKey.currentState!.validate()) {
                        if (widget.isEditMode) {
                          // When in edit mode, pass null as the image file if no new image is selected
                          context.read<CategoryBloc>().add(EditCategoryEvent(
                              categoryId: widget.existingCategory!['id'],
                              newCategoryName:
                                  _categoryNameController.text.trim(),
                              newImageFile:
                                  _selectedImage // This will be null if no new image is selected
                              ));
                        } else {
                          if (_selectedImage != null) {
                            //! add category to fb
                            context.read<CategoryBloc>().add(AddCategoryEvent(
                                _categoryNameController.text.trim(),
                                _selectedImage!));
                          } else {
                            CustomSnackbar.showCustomSnackBar(
                                context, 'Please select an image!',
                                appearFromTop: true, icon: Icons.error);
                          }
                        }
                      }
                    }, child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        return BlueButtonWidget(
                          buttonText: widget.isEditMode
                              ? 'Update Category'
                              : 'Add Category',
                          isLoading: state is CategoryLoading,
                        );
                      },
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
