import 'package:flutter/material.dart';
import 'package:wulflex_admin/features/products/presentation/screens/add_product_screen.dart';
import 'package:wulflex_admin/features/products/presentation/screens/view_inventory_screen.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/shared/widgets/custom_category_button.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class ScreenProductsMain extends StatelessWidget {
  const ScreenProductsMain({super.key});

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
                      name: "Add Items",
                      icon: Icons.add,
                      onTap: () =>
                          NavigationHelper.navigateToWithoutReplacement(context,
                              ScreenAddProducts(screenTitle: 'Add Items'))),
                  SizedBox(width: 20),
                  CustomCategoryButtonWidget(
                      onTap: () =>
                          NavigationHelper.navigateToWithoutReplacement(
                              context,
                              ScreenViewInventory(
                                  screenTitle: 'View Inventory')),
                      name: "View Inventory",
                      icon: Icons.manage_search_sharp),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  CustomCategoryButtonWidget(
                      name: "Sales Dashboard", icon: Icons.bar_chart_sharp),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
