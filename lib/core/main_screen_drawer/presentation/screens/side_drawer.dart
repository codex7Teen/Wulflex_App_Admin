import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/features/categories/presentation/screens/main_catetgory_screen.dart';
import 'package:wulflex_admin/features/reviews/presentation/screens/review_main_screen.dart';
import 'package:wulflex_admin/core/main_screen_drawer/presentation/widgets/drawer_menu_items_widget.dart';
import 'package:wulflex_admin/features/orders/presentation/screens/orders_main_screen.dart';
import 'package:wulflex_admin/features/products/presentation/screens/products_main_screen.dart';
import 'package:wulflex_admin/features/settings/presentation/screens/signout.dart';
import 'package:wulflex_admin/features/users/presentation/screens/screen_users.dart';

class ScreenSideDrawer extends StatefulWidget {
  const ScreenSideDrawer({super.key});

  @override
  State<ScreenSideDrawer> createState() => _ScreenSideDrawerState();
}

class _ScreenSideDrawerState extends State<ScreenSideDrawer> {
  // List to store screens inside the drawer
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();
    //! D R A W E R - S C R E E N S
    _pages = [
      ScreenHiddenDrawer(productsMenu, ScreenProductsMain()),
      ScreenHiddenDrawer(categoryMenu, ScreenMainCategory()),
      ScreenHiddenDrawer(ordersMenu, ScreenOrdersMainScreen()),
      ScreenHiddenDrawer(reviewsMenu, ScreenReviewMain()),
      ScreenHiddenDrawer(usersMenu, ScreenUsers()),
      ScreenHiddenDrawer(settingsMenu, ScreenSignOut()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    //! D R A W E R - P R O P E R T I E S
    return HiddenDrawerMenu(
      screens: _pages,
      backgroundColorMenu: AppColors.blueThemeColor,
      initPositionSelected: 0,
      slidePercent: 50,
      contentCornerRadius: 30,
      enableShadowItensMenu: true,
      elevationAppBar: 10,
      curveAnimation: Curves.easeInOutCubic,
      styleAutoTittleName: AppTextStyles.sideDrawerSelectedHeading
          .copyWith(color: AppColors.blackThemeColor),
      isTitleCentered: true,
      leadingAppBar:
          Icon(Icons.menu, color: AppColors.blackThemeColor, size: 36),
      backgroundColorAppBar: AppColors.xtraLightBlueThemeColor,
    );
  }
}
