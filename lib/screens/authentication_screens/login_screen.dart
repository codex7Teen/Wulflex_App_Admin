import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wulflex_admin/blocs/bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/consts/app_colors.dart';
import 'package:wulflex_admin/consts/text_styles.dart';
import 'package:wulflex_admin/screens/main_screens/home_screen.dart';
import 'package:wulflex_admin/widgets/blue_button_widget.dart';
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
                    context, ScreenHome(),
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
                          style: GoogleFonts.bebasNeue(
                                  textStyle: AppTextStyles.headingLarge)
                              .copyWith(letterSpacing: 1)),
                      SizedBox(height: 14),

                      // email textfield
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Icon(
                              Icons.alternate_email_rounded,
                              color: AppColors.greyThemeColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: TextFormField(
                                  validator: (value) {
                                    // Check if the field is empty
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter you email address';
                                    }
                                    return null;
                                  },
                                  controller: _emailTextController,
                                  decoration: InputDecoration(
                                      hintText: 'Administrator ID',
                                      hintStyle: GoogleFonts.robotoCondensed(
                                          textStyle: AppTextStyles.mediumText
                                              .copyWith(
                                                  color: Colors.grey,
                                                  letterSpacing: 0.5)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.greyThemeColor,
                                              width: 0.4))))),
                        ],
                      ),
                      SizedBox(height: 30),

                      // password field
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.greyThemeColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: TextFormField(
                                  obscureText: !_isPasswordVisible,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                  controller: _passwordTextController,
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isPasswordVisible =
                                                !_isPasswordVisible;
                                          });
                                        },
                                        child: Icon(
                                          _isPasswordVisible
                                              ? Icons.visibility_off_sharp
                                              : Icons.visibility,
                                          color: AppColors.greyThemeColor,
                                        ),
                                      ),
                                      hintText: 'Password',
                                      hintStyle: GoogleFonts.robotoCondensed(
                                          textStyle: AppTextStyles.mediumText
                                              .copyWith(
                                                  color: Colors.grey,
                                                  letterSpacing: 0.5)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.greyThemeColor,
                                              width: 0.4))))),
                        ],
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
