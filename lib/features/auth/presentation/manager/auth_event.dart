part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class RegisterStepOneEvent extends AuthEvent {
  final StepOneRequestModel request;

  RegisterStepOneEvent({required this.request});
}

class RegisterStepTwoEvent extends AuthEvent {
  final StepTwoRequestModel request;

  RegisterStepTwoEvent({required this.request});
}
