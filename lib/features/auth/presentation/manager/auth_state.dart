part of 'auth_bloc.dart';

enum AuthType {
  registerStepOne,
  registerStepTwo,
}

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String message;
  final AuthType authType;

  AuthSuccessState({
    required this.message,
    required this.authType,
  });
}

class AuthFailureState extends AuthState {
  final String message;
  final AuthType authType;

  AuthFailureState({
    required this.message,
    required this.authType,
  });
}
