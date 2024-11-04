import 'package:flutter/material.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';
import 'package:wulflex_admin/screens/main_screens/product_screens/add_product_screens/add_accessories_screen.dart';
import 'package:wulflex_admin/screens/main_screens/product_screens/add_product_screens/add_apparels_screen.dart';
import 'package:wulflex_admin/screens/main_screens/product_screens/add_product_screens/add_clothing_screen.dart';
import 'package:wulflex_admin/screens/main_screens/product_screens/add_product_screens/add_equipments_screen.dart';
import 'package:wulflex_admin/screens/main_screens/product_screens/add_product_screens/add_suppliments_screen.dart';
import 'package:wulflex_admin/widgets/custom_category_button.dart';
import 'package:wulflex_admin/widgets/navigation_helper_widget.dart';

class ScreenAddProducts extends StatelessWidget {
  final String title;
  const ScreenAddProducts({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: AppTextStyles.headLineMedium
                .copyWith(color: AppColors.darkScaffoldColor)),
        centerTitle: true,
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 25,
            )),
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 17),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCategoryButtonWidget(
                      onTap: () =>
                          NavigationHelper.navigateToWithoutReplacement(
                              context,
                              ScreenAddEquipments(
                                  screenTitle: "Add New Equipment")),
                      name: "Add Equipments",
                      icon: Icons.fitness_center_outlined),
                  SizedBox(width: 20),
                  CustomCategoryButtonWidget(
                      onTap: () =>
                          NavigationHelper.navigateToWithoutReplacement(
                              context,
                              ScreenAddSuppliments(
                                  screenTitle: "Add New Suppliment")),
                      name: "Add Suppliments",
                      icon: Icons.medical_services),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  CustomCategoryButtonWidget(
                      onTap: () =>
                          NavigationHelper.navigateToWithoutReplacement(
                              context,
                              ScreenAddClothing(
                                  screenTitle: "Add New Clothing")),
                      name: "Add Clothing",
                      icon: Icons.shopping_bag),
                  SizedBox(width: 20),
                  CustomCategoryButtonWidget(
                      onTap: () =>
                          NavigationHelper.navigateToWithoutReplacement(
                              context,
                              ScreenAddAccessories(
                                  screenTitle: "Add New Accessory")),
                      name: "Add Accessories",
                      icon: Icons.watch),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  CustomCategoryButtonWidget(
                      onTap: () =>
                          NavigationHelper.navigateToWithoutReplacement(
                              context,
                              ScreenAddApparels(
                                  screenTitle: "Add New Apparel")),
                      name: "Add Apparels",
                      icon: Icons.storefront),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
