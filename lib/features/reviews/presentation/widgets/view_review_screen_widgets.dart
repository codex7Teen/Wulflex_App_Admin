import 'package:flutter/material.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';

Widget customReviewProgressPercentageIndicator(BuildContext context,
    String leadingText, String trailingText, double progressValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.star_rounded, color: AppColors.blueThemeColor, size: 25),
      SizedBox(width: 3),
      Text(leadingText,
          style: AppTextStyles.linearProgressIndicatorLeadingText),
      SizedBox(width: 3.5),
      SizedBox(
        width: 130,
        child: LinearProgressIndicator(
          color: AppColors.blueThemeColor,
          backgroundColor: AppColors.lightGreyThemeColor,
          borderRadius: BorderRadius.circular(10),
          minHeight: 10,
          value: progressValue,
        ),
      ),
      SizedBox(width: 3.5),
      Text(trailingText,
          style: AppTextStyles.linearProgressIndicatorTrailingText)
    ],
  );
}