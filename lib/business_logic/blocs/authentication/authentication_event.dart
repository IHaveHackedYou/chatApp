part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SignUp extends AuthenticationEvent {
  final String email, password;
  final bool staySignedIn;

  SignUp(this.email, this.password, this.staySignedIn);

  @override
  List<Object> get props => [email, password];
}

class SignIn extends AuthenticationEvent {
  final String email, password;
  final bool staySignedIn;

  SignIn(this.email, this.password, this.staySignedIn);
  @override
  List<Object> get props => [email, password];
}

class SignOut extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class ResetPassword extends AuthenticationEvent {
  final String email;
  ResetPassword(this.email);
  @override
  List<Object> get props => [email];
}

class TryAutoSignIn extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
