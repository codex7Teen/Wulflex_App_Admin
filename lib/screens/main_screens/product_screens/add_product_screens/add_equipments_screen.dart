import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';
import 'package:wulflex_admin/widgets/appbar_with_back_button_widget.dart';
import 'package:wulflex_admin/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/widgets/custom_add_fields_widget.dart';
import 'package:wulflex_admin/widgets/custom_image_picker_container_widget.dart';
import 'package:wulflex_admin/widgets/custom_weightandsize_selector_container_widget.dart';

class ScreenAddEquipments extends StatefulWidget {
  final String screenTitle;
  const ScreenAddEquipments({super.key, required this.screenTitle});

  @override
  State<ScreenAddEquipments> createState() => _ScreenAddEquipmentsState();
}

class _ScreenAddEquipmentsState extends State<ScreenAddEquipments> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _retailPriceController = TextEditingController();
  TextEditingController _offerPriceController = TextEditingController();

  // Track selected weights
  Set<String> selectedWeights = {};

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
                  child: CustomImagePickerContainerWidget(),
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
                GestureDetector(
                    onTap: () {
                      formKey.currentState!.validate();
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
