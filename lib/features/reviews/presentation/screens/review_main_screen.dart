import 'package:flutter/material.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/reviews/presentation/screens/manage_review_screen.dart';
import 'package:wulflex_admin/shared/widgets/custom_category_button.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class ScreenReviewMain extends StatelessWidget {
  const ScreenReviewMain({super.key});

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
                    onTap: () => NavigationHelper.navigateToWithoutReplacement(
                        context,
                        ScreenManageReviews(
                          screenTitle: 'Manage Reviews',
                        )),
                    name: "Review Management",
                    icon: Icons.assignment,
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
