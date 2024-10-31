import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wulflex_admin/blocs/bloc/authentication_bloc_bloc.dart';
import 'package:wulflex_admin/screens/authentication_screens/login_screen.dart';
import 'package:wulflex_admin/widgets/navigation_helper_widget.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBlocBloc, AuthenticationBlocState>(
        listener: (context, state) {
          if(state is LogOutSuccess) {
            NavigationHelper.navigateToWithReplacement(context, ScreenLogin());
          }
        },
        child: Center(
            child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBlocBloc>(context)
                      .add(LogoutButtonClicked());
                },
                child: Text('signout'))),
      ),
    );
  }
}
