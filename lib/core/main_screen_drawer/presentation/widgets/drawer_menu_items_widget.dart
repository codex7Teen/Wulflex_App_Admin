import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

final productsMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.whiteThemeColor,
  name: 'Products',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerUnSelectedHeading),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerSelectedHeading),
);

final categoryMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.whiteThemeColor,
  name: 'Categories',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerUnSelectedHeading),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerSelectedHeading),
);

final ordersMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.whiteThemeColor,
  name: 'Orders',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerUnSelectedHeading),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerSelectedHeading),
);

final reviewsMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.whiteThemeColor,
  name: 'Reviews',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerUnSelectedHeading),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerSelectedHeading),
);

final chatMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.whiteThemeColor,
  name: 'chats',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerUnSelectedHeading),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerSelectedHeading),
);

final settingsMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.whiteThemeColor,
  name: 'Settings',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerUnSelectedHeading),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.sideDrawerSelectedHeading),
);
