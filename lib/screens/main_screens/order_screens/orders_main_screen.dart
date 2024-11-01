import 'package:flutter/material.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/widgets/custom_category_button.dart';

class ScreenOrdersMainScreen extends StatelessWidget {
  const ScreenOrdersMainScreen({super.key});

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
                    name: "Order Management",
                    icon: Icons.assignment,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCategoryButtonWidget(
                    name: "Delivered Orders",
                    icon: Icons.done_all_rounded,
                  ),
                  SizedBox(width: 20,),
                  CustomCategoryButtonWidget(
                    name: "Cancelled Orders",
                    icon: Icons.cancel,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
