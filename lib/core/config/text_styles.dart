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

  //! REVIEWS TEXT
  static final TextStyle reviewsText = GoogleFonts.robotoCondensed(
      color: AppColors.blackThemeColor,
      fontWeight: FontWeight.w600,
      fontSize: 21,
      letterSpacing: 0.4);
  //! REVIEWS NUMBER BIG BLUE TEXT
  static final TextStyle reviewsNumberBigText = GoogleFonts.bebasNeue(
      fontSize: 42,
      color: AppColors.blueThemeColor,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w600);

  //! EMPTY SECTION TEXT
  static final TextStyle emptySectionText = GoogleFonts.bebasNeue(
      fontSize: 17.5, color: AppColors.blackThemeColor, letterSpacing: 0.8);

  //! VIEW RATINGS BIG RATING TEXT
  static final TextStyle viewRatingBigRatingText = GoogleFonts.bebasNeue(
      textStyle: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
          color: AppColors.blueThemeColor));

  //! TOTAL REVIEWS TEXT
  static TextStyle buildTotalReviewsText = GoogleFonts.bebasNeue(
      fontSize: 17.5,
      color: AppColors.darkishGrey,
      letterSpacing: 2.5,
      fontWeight: FontWeight.w600);

  //! LINEAR PROGESS INDICATOR LEADING TEXT
  static final TextStyle linearProgressIndicatorLeadingText =
      GoogleFonts.robotoCondensed(
          fontSize: 17,
          color: AppColors.blueThemeColor,
          letterSpacing: 2.5,
          fontWeight: FontWeight.w600);

  //! LINEAR PROGESS INDICATOR TRAILING TEXT
  static TextStyle linearProgressIndicatorTrailingText =
      GoogleFonts.robotoCondensed(
          fontSize: 13.2,
          color: AppColors.darkishGrey,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w500);

  //! SELECTED SIZE OR WEIGNT TEXT
  static final TextStyle selectedSizeOrWeightText = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.bold,
      color: AppColors.blackThemeColor,
      fontSize: 14,
      letterSpacing: 0.2);

  //! REVIEW USERNAME TEXT
  static final reviewUsernameText = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.bold,
      color: AppColors.blackThemeColor,
      fontSize: 16,
      letterSpacing: 0.5);

  //! REVIEW DATE TEXT
  static final reviewDateText = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.w500,
      color: AppColors.greyThemeColor,
      fontSize: 11.5,
      letterSpacing: 0.5);

  //! REVIEW ORDERED SIZE OR WEIGHT
  static final reviewOrderdSizeorweightText = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.w500,
      color: AppColors.greyThemeColor,
      fontSize: 14,
      letterSpacing: 0.5);

  //! RATE SCRREEN SUPER MINI TEXT
  static final TextStyle rateScreenSupermini = GoogleFonts.robotoCondensed(
      fontSize: 14, color: AppColors.greyThemeColor, letterSpacing: 0);

  //! DESCRIPTION TEXT
  static final TextStyle descriptionText = GoogleFonts.robotoCondensed(
      textStyle: TextStyle(
    fontSize: 16,
    color: AppColors.darkishGrey,
  ));

  //! ORDER QUANTITY TEXT
  static final TextStyle orderQuantityText = GoogleFonts.bebasNeue(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
      color: AppColors.blackThemeColor);

  //! CONTENT TITLE TEXTS
  static final TextStyle contentTitleTexts = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.bold,
      fontSize: 17,
      color: Colors.black,
      letterSpacing: 0.4);

  //! CHAT HINT TEXT
  static final TextStyle chatHintText = GoogleFonts.robotoCondensed(
    fontSize: 18,
    color: AppColors.greyThemeColor,
  );

  //! CHAT TEXTFIELD TEXT
  static final TextStyle chatTextfieldstyle = GoogleFonts.robotoCondensed(
    fontSize: 18,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
    color: AppColors.blackThemeColor,
  );

  //! CHAT CHATBUBBLE TEXT
  static TextStyle chatBubbleText(bool isMe) => GoogleFonts.robotoCondensed(
        fontSize: 17,
        letterSpacing: 0.6,
        color: isMe ? Colors.white : Colors.black,
      );

  //! CHAT CHATBUBBLE DATE TIME TEXT
  static final TextStyle chatBubbleDateTimeText = GoogleFonts.robotoCondensed(
    fontSize: 10,
    letterSpacing: 0.55,
    color: AppColors.greyThemeColor,
  );

  //! REVENUE SECTION METRICS TOTAL TEXT
  static final TextStyle revenueMetricsTotalText = GoogleFonts.bebasNeue(
      fontSize: 18,
      color: AppColors.blackThemeColor,
      letterSpacing: 0.9,
      fontWeight: FontWeight.w600);

  //! REVENUE SECTION METRICS VALUE TEXT
  static final TextStyle revenueMetricsValueText = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.w600,
      fontSize: 14.5,
      color: Colors.black,
      letterSpacing: 0.5);

  //! REVENUE SECTION ORDER ID AND AMOUNT
  static final TextStyle revenueSectionOrderIdText =
      GoogleFonts.robotoCondensed(
          fontSize: 16,
          color: AppColors.blackThemeColor,
          letterSpacing: 0.4,
          fontWeight: FontWeight.w500);

  //! REVENUE SECTION ORDER DATE TIME TEXT
  static final TextStyle revenueSectionOrderDateText =
      GoogleFonts.robotoCondensed(
          fontSize: 14,
          letterSpacing: 0.3,
          color: AppColors.greyThemeColor,
          fontWeight: FontWeight.w400);

  //! VIEW PRODUCT HEADING TEXT
  static final TextStyle viewProductTitleText = GoogleFonts.bebasNeue(
      textStyle: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: AppColors.blackThemeColor));

  //! OFFER PRICE HEADING TEXT
  static final TextStyle offerPriceHeadingText = GoogleFonts.bebasNeue(
      fontSize: 28,
      color: AppColors.greenThemeColor,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w600);

//! ORIGINAL PRICE TEXT
  static final TextStyle originalPriceText = GoogleFonts.bebasNeue(
      fontSize: 16,
      color: AppColors.darkishGrey,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.lineThrough,
      decorationColor: AppColors.darkishGrey,
      decorationThickness: 1);

//! OFFER PERCENTAGE TEXT
  static final TextStyle offerPercentageText = GoogleFonts.bebasNeue(
    fontSize: 18,
    color: AppColors.blueThemeColor,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w600,
  );

  //! READ MORE & READ LESS TEXT
  static final TextStyle readmoreAndreadLessText = GoogleFonts.robotoCondensed(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.darkishGrey));

  //! SCREEN SUB TITLES
  static final TextStyle screenSubTitles = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.bold,
      color: AppColors.blackThemeColor,
      fontSize: 18,
      letterSpacing: 0.5);

  //! SIZE CHART TEXT
  static final TextStyle sizeChartText = GoogleFonts.robotoCondensed(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.blueThemeColor));

  //! VIEW PRODUCT MAIN HEADING
  static final TextStyle viewProductMainHeading = GoogleFonts.bebasNeue(
      fontSize: 32,
      color: AppColors.blackThemeColor,
      letterSpacing: 3,
      fontWeight: FontWeight.w600);

  //! VIEW PRODUCT RATINGS TEXT
  static final TextStyle viewProductratingsText = GoogleFonts.robotoCondensed(
      fontSize: 14,
      color: AppColors.blueThemeColor,
      letterSpacing: 0.4,
      fontWeight: FontWeight.w400);

        //! BUTTON CARDS TEXT
  static final TextStyle buttonCardsText = GoogleFonts.robotoCondensed(
      textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17.5,
          letterSpacing: 0.8,
          color: AppColors.blackThemeColor));
}
