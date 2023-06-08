part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class LogOutEvent extends AuthEvent {
  final String? errorMessage;
  LogOutEvent([this.errorMessage]);
}

class SetLoggedUserEvent extends AuthEvent {
  final User user;
  SetLoggedUserEvent(this.user);
}
