import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/auth/bloc/authentication_bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';
import 'package:wulflex_admin/shared/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/shared/widgets/custom_auth_textfield_widget.dart';

class LoginWidgets {
  static Widget buildLoginText(BuildContext context) {
    return Center(
      child: Image.asset('assets/Login-amico.png',
          width: MediaQuery.sizeOf(context).width * 0.645),
    );
  }

  static Widget buildWelcomeText() {
    return Text('WELCOME ADMIN',
        style: AppTextStyles.headLineLarge.copyWith(color: Colors.black));
  }

  static Widget buildIdTextfield(TextEditingController emailTextController) {
    return CustomAuthenticationTetxfieldWidget(
        controller: emailTextController,
        hintText: 'Administrator ID',
        icon: Icons.alternate_email_sharp,
        validator: (value) {
          // Check if the field is empty
          if (value == null || value.trim().isEmpty) {
            return 'Please enter you email address';
          }
          return null;
        });
  }

  static Widget buildPasswordTextfield(
      TextEditingController passwordTextController,
      bool isPasswordVisible,
      VoidCallback toggleVisibility) {
    return CustomAuthenticationTetxfieldWidget(
      controller: passwordTextController,
      hintText: 'Password',
      icon: Icons.lock_outline_rounded,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      isPasswordVisible: isPasswordVisible,
      obscureText: true,
      toggleVisibility: toggleVisibility,
    );
  }

  static Widget buildLoginButton(
      GlobalKey<FormState> formKey,
      TextEditingController emailTextController,
      TextEditingController passwordTextController,
      BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (formKey.currentState!.validate()) {
            BlocProvider.of<AuthenticationBlocBloc>(context).add(
                LoginButtonClicked(
                    email: emailTextController.text,
                    password: passwordTextController.text));
          }
        },
        child: BlueButtonWidget(buttonText: 'Login'));
  }
}
