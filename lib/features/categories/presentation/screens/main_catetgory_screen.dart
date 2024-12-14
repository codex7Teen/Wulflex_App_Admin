import 'package:flutter/material.dart';
import 'package:wulflex_admin/features/categories/presentation/screens/add_edit_category_screen.dart';
import 'package:wulflex_admin/features/categories/presentation/screens/category_manage_screen.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/shared/widgets/custom_category_button.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class ScreenMainCategory extends StatelessWidget {
  const ScreenMainCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteThemeColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 17),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCategoryButtonWidget(
                    onTap: () => NavigationHelper.navigateToWithoutReplacement(context, ScreenAddCategory(screenTitle: 'Add Category')),
                      name: "Add Category",
                      icon: Icons.add),
                  SizedBox(width: 20),
                  CustomCategoryButtonWidget(
                      onTap: () => NavigationHelper.navigateToWithoutReplacement(context, ScreenCategoryManage(screenTitle: 'Manage Category')),
                      name: "Category Management",
                      icon: Icons.category_sharp),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}