import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';
import 'package:wulflex_admin/screens/main_screens/analytics_screens/analytics_screen.dart';
import 'package:wulflex_admin/screens/main_screens/drawer_screens/drawer_menu_items_widget.dart';
import 'package:wulflex_admin/screens/main_screens/order_screens/orders_main_screen.dart';
import 'package:wulflex_admin/screens/main_screens/product_screens/products_main_screen.dart';
import 'package:wulflex_admin/screens/main_screens/settings_screen/settings_screen.dart';
import 'package:wulflex_admin/screens/main_screens/users_screens/screen_users.dart';

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
      ScreenHiddenDrawer(ordersMenu, ScreenOrdersMainScreen()),
      ScreenHiddenDrawer(usersMenu, ScreenUsers()),
      ScreenHiddenDrawer(analyticsMenu, ScreenAnalytics()),
      ScreenHiddenDrawer(settingsMenu, ScreenSettings()),
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
      styleAutoTittleName:
          GoogleFonts.bebasNeue(textStyle: AppTextStyles.headingMedium1),
      isTitleCentered: true,
      leadingAppBar:
          Icon(Icons.menu, color: AppColors.darkScaffoldColor, size: 36),
      backgroundColorAppBar: Colors.transparent,
    );
  }
}
