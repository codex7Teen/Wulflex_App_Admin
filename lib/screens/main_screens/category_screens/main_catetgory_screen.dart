import 'package:flutter/material.dart';
import 'package:wulflex_admin/screens/main_screens/category_screens/add_category_screens/add_category_screen.dart';
import 'package:wulflex_admin/utils/consts/app_colors.dart';
import 'package:wulflex_admin/widgets/custom_category_button.dart';
import 'package:wulflex_admin/widgets/navigation_helper_widget.dart';

class ScreenMainCategory extends StatelessWidget {
  const ScreenMainCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightScaffoldColor,
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