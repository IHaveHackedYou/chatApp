part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSignedIn extends AuthenticationState {
  final User user;
  const AuthenticationSignedIn(this.user);
}

class AuthenticationSigningIn extends AuthenticationState {}

class AuthenticationSignInFailed extends AuthenticationState {
  final String errorMessage;
  const AuthenticationSignInFailed(this.errorMessage);
}

class AuthenticationSigningUp extends AuthenticationState {}

class AuthenticationSignUpFailed extends AuthenticationState {
  final String errorMessage;
  const AuthenticationSignUpFailed(this.errorMessage);
}

class AuthenticationResettingPasswordFailed extends AuthenticationState {
  final String errorMessage;
  const AuthenticationResettingPasswordFailed(this.errorMessage);
}

class AuthenticationSigningOut extends AuthenticationState {}
