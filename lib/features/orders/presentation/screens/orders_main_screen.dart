import 'package:flutter/material.dart';
import 'package:wulflex_admin/features/orders/presentation/screens/order_manage_screen.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/shared/widgets/custom_category_button.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

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
                    onTap: () => NavigationHelper.navigateToWithoutReplacement(context, ScreenOrderManage()),
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
                    icon: Icons.done_all,
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
