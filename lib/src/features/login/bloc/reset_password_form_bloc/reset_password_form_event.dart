part of 'reset_password_form_bloc.dart';

/// Base class for all Reset Password Form input events adhering to Rule 4.2.
sealed class ResetPasswordFormEvent extends Equatable {
  const ResetPasswordFormEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordPasswordChangedEvent extends ResetPasswordFormEvent {
  final String password;

  const ResetPasswordPasswordChangedEvent(this.password);

  @override
  List<Object?> get props => [password];
}

class ResetPasswordConfirmPasswordChangedEvent extends ResetPasswordFormEvent {
  final String passwordConfirm;

  const ResetPasswordConfirmPasswordChangedEvent(this.passwordConfirm);

  @override
  List<Object?> get props => [passwordConfirm];
}
