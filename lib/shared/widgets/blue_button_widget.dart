import 'package:flutter/material.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';

class BlueButtonWidget extends StatelessWidget {
  final bool isLoading;
  final String buttonText;
  const BlueButtonWidget(
      {super.key, required this.buttonText, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.93,
      height: MediaQuery.sizeOf(context).height * 0.065,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.blueThemeColor),
      child: Center(
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: AppColors.lightScaffoldColor))
            : Text(
                buttonText,
                style: AppTextStyles.titleMedium,
              ),
      ),
    );
  }
}
