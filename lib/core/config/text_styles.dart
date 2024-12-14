import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';

class AppTextStyles {
  //! SIDE DRAWER SELECTED HEADING
  static final TextStyle sideDrawerSelectedHeading = GoogleFonts.bebasNeue(
      fontSize: 33, color: AppColors.whiteThemeColor, letterSpacing: 1);

//! SIDE DRAWER UNSELECTED HEADING
  static final TextStyle sideDrawerUnSelectedHeading = GoogleFonts.bebasNeue(
      fontSize: 22, color: Colors.white, letterSpacing: 1);

//! SCREEN SUB TITLE
  static final TextStyle screenSubTitleText = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
      letterSpacing: 1);

  static final TextStyle sideDrawerSelectedHeadingSmall = GoogleFonts.bebasNeue(
      fontSize: 24, color: Colors.black, letterSpacing: 1);

  static final TextStyle headLineLarge = GoogleFonts.bebasNeue(
      fontSize: 40, color: Colors.white, letterSpacing: 1);

  static final TextStyle titleSmall = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: Colors.grey,
      letterSpacing: 1);

  static final TextStyle titleSmallThin = GoogleFonts.robotoCondensed(
      fontSize: 16, color: Colors.grey, letterSpacing: 0.5);

  static final TextStyle titleXSmall = GoogleFonts.robotoCondensed(
      fontSize: 14,
      color: Colors.white,
      letterSpacing: 1,
      fontWeight: FontWeight.bold);

  static final TextStyle titleXSmallThin = GoogleFonts.robotoCondensed(
      fontSize: 14, color: Colors.grey, letterSpacing: 0.6);

  static final TextStyle titleMedium = GoogleFonts.robotoCondensed(
      fontSize: 18,
      color: Colors.white,
      letterSpacing: 0.9,
      fontWeight: FontWeight.bold);

  static final TextStyle bodySmall = GoogleFonts.robotoCondensed(
      fontSize: 14,
      color: Colors.white,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400);

  //! MINI TEXT BOLD
  static final TextStyle miniTextBold = GoogleFonts.robotoCondensed(
      color: AppColors.blackThemeColor,
      fontWeight: FontWeight.w600,
      fontSize: 15,
      letterSpacing: 0.6);

  //! MINI TEXT SIMPLE
  static final TextStyle miniTextSimple = GoogleFonts.robotoCondensed(
      color: AppColors.darkishGrey,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      letterSpacing: 0.4);

  //! SCREEN SUB HEADING
  static final TextStyle screenSubHeading = GoogleFonts.bebasNeue(
      fontSize: 22,
      color: AppColors.blackThemeColor,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w600);

  //! ITEM-CARD BRAND TEXT (ITEM BRAND)
  static final TextStyle itemCardBrandText = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.bold,
      color: AppColors.blackThemeColor,
      fontSize: 17.5,
      letterSpacing: 1);

  //! ITEM-CARD PRODUCT NAME TEXT (ITEM NAME)
  static final TextStyle itemCardNameText = GoogleFonts.robotoCondensed(
    fontWeight: FontWeight.bold,
    color: AppColors.greyThemeColor,
    fontSize: 12.5,
    letterSpacing: 0.8,
  );

  //! ITEM-CARD SECOND SUB-TITLE TEXT (retail PRICE)
  static final TextStyle itemCardSecondSubTitleText =
      GoogleFonts.robotoCondensed(
          fontWeight: FontWeight.bold,
          color: AppColors.greyThemeColor,
          fontSize: 14,
          letterSpacing: 0.2,
          decoration: TextDecoration.lineThrough,
          decorationColor: AppColors.greyThemeColor,
          decorationThickness: 1);

  //! ITEM-CARD SUB-TITLE TEXT (PRICE)
  static final TextStyle itemCardSubTitleText = GoogleFonts.robotoCondensed(
    fontWeight: FontWeight.bold,
    color: AppColors.greenThemeColor,
    fontSize: 16.5,
    letterSpacing: 0.2,
  );

  //! ADDRESS LIST ADDRESS NAME TEXT
  static final TextStyle addressNameText = GoogleFonts.robotoCondensed(
      textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 19,
          letterSpacing: 0.35,
          color: AppColors.blackThemeColor));

  //! ADDRESS LIST ALL LIST ITEMS TEXT
  static final TextStyle addressListItemsText = GoogleFonts.robotoCondensed(
      textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          letterSpacing: 0.3,
          color: AppColors.blackThemeColor));
}
