import 'package:flutter/material.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';

class CustomCategoryButtonWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback? onTap;
  const CustomCategoryButtonWidget(
      {super.key, required this.name, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.blueThemeColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.lightScaffoldColor, size: 28),
              SizedBox(height: 4),
              Text(name,
                  style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.lightScaffoldColor,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
