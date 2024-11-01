import 'package:flutter/material.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';

class BlueButtonWidget extends StatelessWidget {
  final String buttonText;
  const BlueButtonWidget({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
                  width: MediaQuery.sizeOf(context).width * 0.93,
                  height: MediaQuery.sizeOf(context).height * 0.065,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.blueThemeColor),
                  child: Center(
                    child: Text(
                      buttonText,
                      style: AppTextStyles.titleMedium,
                    ),
                  ),
                );
  }
}