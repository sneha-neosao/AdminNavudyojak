part of 'forgot_password_form_bloc.dart';

/// Base state for Forgot Password Form Validation BLoC adhering to Rule 4.2.
sealed class ForgotPasswordFormState extends Equatable {
  final String email;
  final bool isValid;

  const ForgotPasswordFormState({
    required this.email,
    required this.isValid,
  });

  @override
  List<Object?> get props => [email, isValid];
}

/// Initial empty form state
class ForgotPasswordFormInitialState extends ForgotPasswordFormState {
  const ForgotPasswordFormInitialState()
      : super(
          email: '',
          isValid: false,
        );
}

/// Validated form data state representing the current input snapshot
class ForgotPasswordFormDataState extends ForgotPasswordFormState {
  final String inputEmail;
  final bool inputIsValid;

  const ForgotPasswordFormDataState({
    required this.inputEmail,
    required this.inputIsValid,
  }) : super(
          email: inputEmail,
          isValid: inputIsValid,
        );

  @override
  List<Object?> get props => [inputEmail, inputIsValid];
}
