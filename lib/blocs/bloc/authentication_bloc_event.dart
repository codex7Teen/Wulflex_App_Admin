part of 'authentication_bloc_bloc.dart';

abstract class AuthenticationBlocEvent extends Equatable {
  const AuthenticationBlocEvent();

  @override
  List<Object> get props => [];
}

//! S H A R E D - P R E F S
class LoginButtonClicked extends AuthenticationBlocEvent {
  final String email;
  final String password;

  LoginButtonClicked({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutButtonClicked extends AuthenticationBlocEvent {}