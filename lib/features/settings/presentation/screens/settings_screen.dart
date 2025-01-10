import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/auth/bloc/authentication_bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/features/auth/presentation/screens/login_screen.dart';
import 'package:wulflex_admin/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:wulflex_admin/features/settings/presentation/screens/terms_and_conditions_screen.dart';
import 'package:wulflex_admin/features/settings/presentation/widgets/settings_screen_widgets.dart';
import 'package:wulflex_admin/shared/widgets/alert_boxes_widgets.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

class ScreenSignOut extends StatelessWidget {
  const ScreenSignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBlocBloc, AuthenticationBlocState>(
      listener: (context, state) {
        if (state is LogOutSuccess) {
          NavigationHelper.navigateToWithReplacement(context, ScreenLogin());
          CustomSnackbar.showCustomSnackBar(context, "Log-out success...",
              icon: Icons.done);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 25, left: 18, right: 18, bottom: 18),
          child: Column(
            children: [
              SettingsScreenWidgets.buildButtonCards(
                  onTap: () => CustomAlertBox.showDeleteConfirmationDialog(
                      context,
                      productName: '',
                      onDeleteConfirmed: () => context
                          .read<AuthenticationBlocBloc>()
                          .add(LogoutButtonClicked()),
                      isSignout: true),
                  icon: Icons.logout,
                  name: 'LOG-OUT'),
              SizedBox(height: 14),
              SettingsScreenWidgets.buildButtonCards(
                  onTap: () => NavigationHelper.navigateToWithoutReplacement(
                      context, PrivacyPolicyScreen()),
                  icon: Icons.security,
                  name: "PRIVACY POLICY"),
              SizedBox(height: 14),
              SettingsScreenWidgets.buildButtonCards(
                  onTap: () => NavigationHelper.navigateToWithoutReplacement(
                      context, TermsAndConditionsScreen()),
                  icon: Icons.assignment,
                  name: "TERMS & CONDITIONS"),
            ],
          ),
        ),
      ),
    );
  }
}
