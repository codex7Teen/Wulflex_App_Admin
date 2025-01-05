import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/features/auth/bloc/authentication_bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/features/auth/presentation/widgets/login_screen_widgets.dart';
import 'package:wulflex_admin/core/main_screen_drawer/presentation/screens/side_drawer.dart';
import 'package:wulflex_admin/shared/widgets/custom_snacbar.dart';
import 'package:wulflex_admin/shared/widgets/navigation_helper_widget.dart';

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
        backgroundColor: AppColors.whiteThemeColor,
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
                      LoginWidgets.buildLoginText(context),
                      SizedBox(height: 45),
                      // heading
                      LoginWidgets.buildWelcomeText(),
                      SizedBox(height: 14),

                      // email textfield
                      LoginWidgets.buildIdTextfield(_emailTextController),
                      SizedBox(height: 30),

                      // password field
                      LoginWidgets.buildPasswordTextfield(
                          _passwordTextController,
                          _isPasswordVisible,
                          () => setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              })),
                      SizedBox(height: 25),

                      //! L O G I N - B U T T O N
                      LoginWidgets.buildLoginButton(
                          _formKey,
                          _emailTextController,
                          _passwordTextController,
                          context),
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
