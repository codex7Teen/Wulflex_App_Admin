import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/blocs/authentication_bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/utils/consts/app_colors.dart';
import 'package:wulflex_admin/screens/authentication_screens/widgets/login_widgets.dart';
import 'package:wulflex_admin/screens/main_screens/drawer_screens/side_drawer.dart';
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
                      buildLoginText(context),
                      SizedBox(height: 45),
                      // heading
                      buildWelcomeText(),
                      SizedBox(height: 14),

                      // email textfield
                      buildIdTextfield(_emailTextController),
                      SizedBox(height: 30),

                      // password field
                      buildPasswordTextfield(
                          _passwordTextController,
                          _isPasswordVisible,
                          () => setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              })),
                      SizedBox(height: 25),

                      //! L O G I N - B U T T O N
                      buildLoginButton(_formKey, _emailTextController,
                          _passwordTextController, context),
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
