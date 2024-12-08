import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:wulflex_admin/utils/consts/app_colors.dart';
import 'package:wulflex_admin/utils/consts/text_styles.dart';

class CustomImagePickerContainerWidget extends StatelessWidget {
  final VoidCallback onTap;
  final List<String> imagePaths;
  const CustomImagePickerContainerWidget(
      {super.key, required this.onTap, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 1.5,
        dashPattern: [6, 6],
        borderType: BorderType.RRect,
        radius: Radius.circular(20),
        child: Container(
          height: 100,
          width: MediaQuery.sizeOf(context).width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: imagePaths.isEmpty
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/Add Image.png',
                          color: AppColors.blueThemeColor, scale: 14),
                      SizedBox(width: 8),
                      Text(
                          'Tap here & upload upto 4 images...\n Upload atleast one image!',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.darkScaffoldColor)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: imagePaths.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: imagePaths[index].startsWith('http')
                              ? Image.network(
                                  imagePaths[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error);
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    // show image loading indicator
                                    return Center(
                                        child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null));
                                  },
                                )
                              : Image.file(
                                  File(imagePaths[index]),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
