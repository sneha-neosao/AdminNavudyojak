part of 'auth_login_form_bloc.dart';

/// Base class for all form input events
sealed class LoginFormEvent extends Equatable {
  const LoginFormEvent();

  @override
  List<Object?> get props => [];
}

/// Listens for changes in email input
class LoginFormEmailChangedEvent extends LoginFormEvent {
  final String email;

  const LoginFormEmailChangedEvent(this.email);

  @override
  List<Object?> get props => [email];
}

/// Listens for changes in password input
class LoginFormPasswordChangedEvent extends LoginFormEvent {
  final String password;

  const LoginFormPasswordChangedEvent(this.password);

  @override
  List<Object?> get props => [password];
}
