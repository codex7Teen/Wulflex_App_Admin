import 'package:flutter/material.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';

class AppbarWithbackbuttonWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String appBarTitle;
  const AppbarWithbackbuttonWidget({super.key, required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: Text(
          appBarTitle,
          style: AppTextStyles.headLineMedium
              .copyWith(color: AppColors.darkScaffoldColor),
        ),
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 25,
            )));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
