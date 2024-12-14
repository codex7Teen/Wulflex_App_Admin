import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/auth/bloc/authentication_bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/features/auth/presentation/screens/login_screen.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class ScreenSignOut extends StatelessWidget {
  const ScreenSignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBlocBloc, AuthenticationBlocState>(
        listener: (context, state) {
          if (state is LogOutSuccess) {
            CustomSnackbar.showCustomSnackBar(context, "Logout success!!");
            NavigationHelper.navigateToWithReplacement(context, ScreenLogin());
          }
        },
        child: Center(
            child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBlocBloc>(context)
                      .add(LogoutButtonClicked());
                },
                child: Text('SIGN OUT',
                    style: AppTextStyles.titleMedium
                        .copyWith(color: AppColors.blackThemeColor)))),
      ),
    );
  }
}