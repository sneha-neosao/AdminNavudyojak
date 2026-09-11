part of 'change_password_form_bloc.dart';

/// Base state for Change Password Form Validation BLoC adhering to Rule 4.2.
sealed class ChangePasswordFormState extends Equatable {
  final String password;
  final String passwordConfirm;
  final bool isValid;

  const ChangePasswordFormState({
    required this.password,
    required this.passwordConfirm,
    required this.isValid,
  });

  @override
  List<Object?> get props => [password, passwordConfirm, isValid];
}

/// Initial empty form state
class ChangePasswordFormInitialState extends ChangePasswordFormState {
  const ChangePasswordFormInitialState()
    : super(password: '', passwordConfirm: '', isValid: false);
}

/// Validated form data state representing the current input snapshot
class ChangePasswordFormDataState extends ChangePasswordFormState {
  final String inputPassword;
  final String inputPasswordConfirm;
  final bool inputIsValid;

  const ChangePasswordFormDataState({
    required this.inputPassword,
    required this.inputPasswordConfirm,
    required this.inputIsValid,
  }) : super(
         password: inputPassword,
         passwordConfirm: inputPasswordConfirm,
         isValid: inputIsValid,
       );

  @override
  List<Object?> get props => [
    inputPassword,
    inputPasswordConfirm,
    inputIsValid,
  ];
}
