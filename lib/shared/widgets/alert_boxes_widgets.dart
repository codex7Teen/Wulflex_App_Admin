import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';

class CustomAlertBox {
  static Future<void> showDeleteConfirmationDialog(BuildContext context,
      {required String productName,
      required VoidCallback onDeleteConfirmed,
      isSignout = false}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: AppColors.lightGreyThemeColor,
          title: Text(
            'Are you sure?',
            style: GoogleFonts.robotoCondensed(
              fontWeight: FontWeight.bold,
              color: AppColors.blackThemeColor,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
          content: isSignout
              ? Text('You are about to log-out from wulflex admin.')
              : Text(
                  'Are you sure you want to delete the category "$productName"? All products within this category will also be deleted. This action is irreversible.',
                  style: GoogleFonts.robotoCondensed(
                    color: AppColors.darkishGrey,
                    fontSize: 16,
                  ),
                ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.blackThemeColor,
                backgroundColor: AppColors.lightGreyThemeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.robotoCondensed(
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackThemeColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isSignout ? Icons.logout : Icons.delete, size: 20),
                  SizedBox(width: 8),
                  Text(
                    isSignout ? 'Log-out' : 'Delete',
                    style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onDeleteConfirmed();
              },
            ),
          ],
        );
      },
    );
  }
}
