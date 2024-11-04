import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wulflex_admin/consts/text_styles.dart';
import 'package:wulflex_admin/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/widgets/custom_add_fields_widget.dart';
import 'package:wulflex_admin/widgets/custom_image_picker_container_widget.dart';
import 'package:wulflex_admin/widgets/custom_snacbar.dart';

class ScreenAddSuppliments extends StatefulWidget {
  final String screenTitle;
  const ScreenAddSuppliments({super.key, required this.screenTitle});

  @override
  State<ScreenAddSuppliments> createState() => _ScreenAddSupplimentsState();
}

class _ScreenAddSupplimentsState extends State<ScreenAddSuppliments> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _retailPriceController = TextEditingController();
  TextEditingController _offerPriceController = TextEditingController();

  // List to store picked image path
  List<String> selectedImages = [];

  // Checkbox State
  bool isAgreed = false;

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
                      value: isAgreed,
                      onChanged: (value) => setState(() {
                            isAgreed = value ?? false;
                          })),
                ),
                SizedBox(height: 25),
                GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.validate() &&
                          selectedImages.isEmpty) {
                        CustomSnackbar.showCustomSnackBar(
                            context, "Please upload an image",
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
