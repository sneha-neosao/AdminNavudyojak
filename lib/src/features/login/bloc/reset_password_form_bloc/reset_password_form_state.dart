part of 'reset_password_form_bloc.dart';

/// Base state for Reset Password Form Validation BLoC adhering to Rule 4.2.
sealed class ResetPasswordFormState extends Equatable {
  final String password;
  final String passwordConfirm;
  final bool isValid;

  const ResetPasswordFormState({
    required this.password,
    required this.passwordConfirm,
    required this.isValid,
  });

  @override
  List<Object?> get props => [password, passwordConfirm, isValid];
}

class ResetPasswordFormInitialState extends ResetPasswordFormState {
  const ResetPasswordFormInitialState()
      : super(
          password: '',
          passwordConfirm: '',
          isValid: false,
        );
}

class ResetPasswordFormDataState extends ResetPasswordFormState {
  const ResetPasswordFormDataState({
    required super.password,
    required super.passwordConfirm,
    required super.isValid,
  });
}
