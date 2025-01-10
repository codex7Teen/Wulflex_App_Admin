import 'package:flutter/material.dart';
import 'package:wulflex_admin/features/settings/presentation/widgets/terms_and_conditions_screen_widgets.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminTermsAndConditionsScreenWidgets.buildAppbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:
            AdminTermsAndConditionsScreenWidgets.buildTermsAndConditionsContent(
                context),
      ),
    );
  }
}
