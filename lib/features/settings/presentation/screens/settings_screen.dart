import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/auth/bloc/authentication_bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/features/settings/presentation/widgets/settings_screen_widgets.dart';
import 'package:wulflex_admin/shared/widgets/alert_boxes_widgets.dart';

class ScreenSignOut extends StatelessWidget {
  const ScreenSignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                name: 'Sign-Out'),
            SizedBox(height: 14),
            SettingsScreenWidgets.buildButtonCards(
                icon: Icons.security, name: "PRIVACY POLICY"),
            SizedBox(height: 14),
            SettingsScreenWidgets.buildButtonCards(
                icon: Icons.assignment, name: "TERMS & CONDITIONS"),
          ],
        ),
      ),
    );
  }
}
