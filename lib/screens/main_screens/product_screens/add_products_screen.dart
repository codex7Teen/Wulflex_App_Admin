import 'package:flutter/material.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';
import 'package:wulflex_admin/widgets/custom_category_button.dart';

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
                      name: "Add Equipments",
                      icon: Icons.fitness_center_outlined),
                  SizedBox(width: 20),
                  CustomCategoryButtonWidget(
                      name: "Add Suppliments", icon: Icons.medical_services),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  CustomCategoryButtonWidget(
                      name: "Add Clothing", icon: Icons.shopping_bag),
                  SizedBox(width: 20),
                  CustomCategoryButtonWidget(
                      name: "Add Accessories", icon: Icons.watch),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  CustomCategoryButtonWidget(
                      name: "Add Apparels", icon: Icons.storefront),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
