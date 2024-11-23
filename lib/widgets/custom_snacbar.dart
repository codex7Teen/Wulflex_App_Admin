import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/utils/consts/app_colors.dart';

class CustomSnackbar {
  static void showCustomSnackBar(BuildContext context, String message,
      {IconData icon = Icons.done_outline_rounded,
      bool applyErrorIconColor = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: applyErrorIconColor
                  ? AppColors.redErrorColor
                  : AppColors.lightScaffoldColor,
              size: 18,
            ),
            SizedBox(width: 15),
            Text(
              overflow: TextOverflow.ellipsis,
              message,
              style: GoogleFonts.robotoCondensed(
                color: AppColors.lightScaffoldColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: AppColors.darkScaffoldColor,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: 9,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}
