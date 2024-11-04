import 'package:flutter/material.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/screens/main_screens/product_screens/add_product_screens/add_products_screen.dart';
import 'package:wulflex_admin/widgets/custom_category_button.dart';
import 'package:wulflex_admin/widgets/navigation_helper_widget.dart';

class ScreenProductsMain extends StatelessWidget {
  const ScreenProductsMain({super.key});

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
                      name: "Add Items",
                      icon: Icons.add,
                      onTap: () =>
                          NavigationHelper.navigateToWithoutReplacement(
                              context,
                              ScreenAddProducts(
                                title: 'Add Items',
                              ))),
                  SizedBox(width: 20),
                  CustomCategoryButtonWidget(
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