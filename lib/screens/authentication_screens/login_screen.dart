import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/blocs/bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';
import 'package:wulflex_admin/screens/main_screens/drawer_screens/side_drawer.dart';
import 'package:wulflex_admin/widgets/blue_button_widget.dart';
import 'package:wulflex_admin/widgets/custom_auth_textfield_widget.dart';
import 'package:wulflex_admin/widgets/custom_snacbar.dart';
import 'package:wulflex_admin/widgets/navigation_helper_widget.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  // key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // email text controller
  final TextEditingController _emailTextController = TextEditingController();
  // password text controller
  final TextEditingController _passwordTextController = TextEditingController();
  // boolean for password visiblity
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightScaffoldColor,
        body: SingleChildScrollView(
          child: BlocListener<AuthenticationBlocBloc, AuthenticationBlocState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                CustomSnackbar.showCustomSnackBar(
                    context, "Login success...  🎉🎉🎉");
                NavigationHelper.navigateToWithReplacement(
                    context, ScreenSideDrawer(),
                    milliseconds: 600);
              } else if (state is LoginFailture) {
                CustomSnackbar.showCustomSnackBar(context, state.error,
                    icon: Icons.error_outline_rounded);
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 75),

                      // image
                      Center(
                        child: Image.asset('assets/Login-amico.png',
                            width: MediaQuery.sizeOf(context).width * 0.645),
                      ),
                      SizedBox(height: 45),

                      // heading
                      Text('WELCOME ADMIN',
                          style: AppTextStyles.headLineLarge
                              .copyWith(color: Colors.black)),
                      SizedBox(height: 14),

                      // email textfield
                      CustomAuthenticationTetxfieldWidget(
                          controller: _emailTextController,
                          hintText: 'Administrator ID',
                          icon: Icons.alternate_email_sharp,
                          validator: (value) {
                            // Check if the field is empty
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter you email address';
                            }
                            return null;
                          }),
                      SizedBox(height: 30),

                      // password field
                      CustomAuthenticationTetxfieldWidget(
                        controller: _passwordTextController,
                        hintText: 'Password',
                        icon: Icons.lock_outline_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        isPasswordVisible: _isPasswordVisible,
                        obscureText: true,
                        toggleVisibility: () => setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        }),
                      ),
                      SizedBox(height: 25),

                      //! L O G I N - B U T T O N
                      GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthenticationBlocBloc>(context)
                                  .add(LoginButtonClicked(
                                      email: _emailTextController.text,
                                      password: _passwordTextController.text));
                            }
                          },
                          child: BlueButtonWidget(buttonText: 'Login')),
                      SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
