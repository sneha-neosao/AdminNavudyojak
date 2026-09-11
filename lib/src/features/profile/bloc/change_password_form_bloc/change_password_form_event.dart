part of 'change_password_form_bloc.dart';

/// Base class for all Change Password form input events adhering to Rule 4.2.
sealed class ChangePasswordFormEvent extends Equatable {
  const ChangePasswordFormEvent();

  @override
  List<Object?> get props => [];
}

/// Listens for changes in password input
class ChangePasswordPasswordChangedEvent extends ChangePasswordFormEvent {
  final String password;

  const ChangePasswordPasswordChangedEvent(this.password);

  @override
  List<Object?> get props => [password];
}

/// Listens for changes in confirm password input
class ChangePasswordConfirmChangedEvent extends ChangePasswordFormEvent {
  final String passwordConfirm;

  const ChangePasswordConfirmChangedEvent(this.passwordConfirm);

  @override
  List<Object?> get props => [passwordConfirm];
}

/// Event to reset form
class ChangePasswordFormResetEvent extends ChangePasswordFormEvent {}
