part of 'forgot_password_form_bloc.dart';

/// Base class for all forgot password form input events adhering to Rule 4.2.
sealed class ForgotPasswordFormEvent extends Equatable {
  const ForgotPasswordFormEvent();

  @override
  List<Object?> get props => [];
}

/// Listens for changes in forgot password email input
class ForgotPasswordEmailChangedEvent extends ForgotPasswordFormEvent {
  final String email;

  const ForgotPasswordEmailChangedEvent(this.email);

  @override
  List<Object?> get props => [email];
}
