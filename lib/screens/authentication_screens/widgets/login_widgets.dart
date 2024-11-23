import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/blocs/authentication_bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/utils/consts/text_styles.dart';
import 'package:wulflex_admin/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/widgets/custom_auth_textfield_widget.dart';

Widget buildLoginText(BuildContext context) {
  return Center(
    child: Image.asset('assets/Login-amico.png',
        width: MediaQuery.sizeOf(context).width * 0.645),
  );
}

Widget buildWelcomeText() {
  return Text('WELCOME ADMIN',
      style: AppTextStyles.headLineLarge.copyWith(color: Colors.black));
}

Widget buildIdTextfield(TextEditingController emailTextController) {
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

Widget buildPasswordTextfield(TextEditingController passwordTextController,
    bool isPasswordVisible, VoidCallback toggleVisibility) {
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

Widget buildLoginButton(
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
