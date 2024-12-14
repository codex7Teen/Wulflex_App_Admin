part of 'authentication_bloc_bloc.dart';

abstract class AuthenticationBlocState extends Equatable {
  const AuthenticationBlocState();
  
  @override
  List<Object> get props => [];
}

final class AuthenticationBlocInitial extends AuthenticationBlocState {}

//! S H A R E D - P R E F S
//! Login
class LoginLoading extends AuthenticationBlocState {}

class LoginSuccess extends AuthenticationBlocState {}

class LoginFailture extends AuthenticationBlocState{
  final String error;

  LoginFailture({required this.error});

  @override
  List<Object> get props => [error];
}

//! Logout
class LogOutSuccess extends AuthenticationBlocState {}
