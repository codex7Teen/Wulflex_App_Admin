import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

final productsMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.lightScaffoldColor,
  name: 'PRODUCTS',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.headingSmall1.copyWith(color: AppColors.lightScaffoldColor)),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.headingMedium1.copyWith(color: AppColors.lightScaffoldColor)),
);

final ordersMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.lightScaffoldColor,
  name: 'Orders',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.headingSmall1.copyWith(color: AppColors.lightScaffoldColor)),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.headingMedium1.copyWith(color: AppColors.lightScaffoldColor)),
);

final usersMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.lightScaffoldColor,
  name: 'Users',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.headingSmall1.copyWith(color: AppColors.lightScaffoldColor)),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.headingMedium1.copyWith(color: AppColors.lightScaffoldColor)),
);

final analyticsMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.lightScaffoldColor,
  name: 'Analytics',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.headingSmall1.copyWith(color: AppColors.lightScaffoldColor)),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.headingMedium1.copyWith(color: AppColors.lightScaffoldColor)),
);

final settingsMenu = ItemHiddenMenu(
  colorLineSelected: AppColors.lightScaffoldColor,
  name: 'Settings',
  baseStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.headingSmall1.copyWith(color: AppColors.lightScaffoldColor)),
  selectedStyle: GoogleFonts.bebasNeue(
      textStyle: AppTextStyles.headingMedium1.copyWith(color: AppColors.lightScaffoldColor)),
);
