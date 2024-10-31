import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_bloc_event.dart';
part 'authentication_bloc_state.dart';

class AuthenticationBlocBloc extends Bloc<AuthenticationBlocEvent, AuthenticationBlocState> {
  AuthenticationBlocBloc() : super(AuthenticationBlocInitial()) {
    //! Saving logged in state
    on<LoginButtonClicked>((event, emit) async {
      emit(LoginLoading());
        if (event.email == 'admin@123' && event.password == 'admin123') {
          // Save login State
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          log("LOG IN SUCCESS AND SHARED PREFS SAVED SUCCESS");
          emit(LoginSuccess());
        } else {
          emit(LoginFailture(error: "Invalide Credentials"));
        }
    });

    //! Saving logged out state
    on<LogoutButtonClicked>((event, emit) async {
       final prefs = await SharedPreferences.getInstance();
       await prefs.setBool('isLoggedIn', false);
       emit(LogOutSuccess());
    });
  }
}
