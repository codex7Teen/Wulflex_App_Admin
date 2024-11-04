import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';

class CustomImagePickerContainerWidget extends StatelessWidget {
  const CustomImagePickerContainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
                  color: Colors.grey, // Set the color of the dotted border
                  strokeWidth: 1.5, // Thickness of the border
                  dashPattern: [6, 6], // Customize the dash pattern
                  borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  child: Container(
                    height: 100,
                    width: MediaQuery.sizeOf(context).width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 5),
                          Text('Upload upto 4 images...',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.darkScaffoldColor)),
                        ],
                      ),
                    ),
                  ),
                );
  }
}