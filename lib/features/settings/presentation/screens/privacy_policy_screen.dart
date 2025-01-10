import 'package:flutter/material.dart';
import 'package:wulflex_admin/features/settings/presentation/widgets/privacy_policy_screen_widgets.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminPrivacyPolicyScreenWidgets.buildAppbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:
            AdminPrivacyPolicyScreenWidgets.buildPrivacyPolicyContent(context),
      ),
    );
  }
}
