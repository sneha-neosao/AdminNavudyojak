part of 'auth_login_bloc.dart';

sealed class AuthLoginState extends Equatable {
  const AuthLoginState();
  @override
  List<Object?> get props => [];
}

class AuthLoginInitialState extends AuthLoginState {}

/// States representing login operation
class AuthLoginLoadingState extends AuthLoginState {}

class AuthLoginSuccessState extends AuthLoginState {
  final LoginResponse data;

  const AuthLoginSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AuthLoginFailureState extends AuthLoginState {
  final String message;

  const AuthLoginFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

/// States representing login status check
class AuthCheckSignInStatusLoadingState extends AuthLoginState {}

class AuthCheckSignInStatusSuccessState extends AuthLoginState {
  final LoginResponse data;
  const AuthCheckSignInStatusSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AuthCheckSignInStatusFailureState extends AuthLoginState {
  final String message;

  const AuthCheckSignInStatusFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

/// States representing logout operation
class AuthLogoutLoadingState extends AuthLoginState {}

class AuthLogoutSuccessState extends AuthLoginState {
  final LogoutResponse data;

  const AuthLogoutSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class AuthLogoutFailureState extends AuthLoginState {
  final String message;

  const AuthLogoutFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
