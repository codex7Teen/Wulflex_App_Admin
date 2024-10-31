import 'package:flutter/material.dart';
import 'package:wulflex_admin/consts/app_colors.dart';

class ScreenProductsMain extends StatelessWidget {
  const ScreenProductsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightScaffoldColor,
      body: Center(child: Text('PRODUCTS MAIN SCREEN'),),
    );
  }
}