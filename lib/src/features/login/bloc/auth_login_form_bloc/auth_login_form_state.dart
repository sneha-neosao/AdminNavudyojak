part of 'auth_login_form_bloc.dart';

/// Base state for Form Validation BLoC.
sealed class LoginFormState extends Equatable {
  final String email;
  final String password;
  final bool isValid;

  const LoginFormState({
    required this.email,
    required this.password,
    required this.isValid,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        isValid,
      ];
}

/// Initial empty form state
class LoginFormInitialState extends LoginFormState {
  const LoginFormInitialState()
      : super(
          email: "",
          password: "",
          isValid: false,
        );
}

/// Validated form data state representing the current input snapshot
class LoginFormDataState extends LoginFormState {
  final String inputEmail;
  final String inputPassword;
  final bool inputIsValid;

  const LoginFormDataState({
    required this.inputEmail,
    required this.inputPassword,
    required this.inputIsValid,
  }) : super(
          email: inputEmail,
          password: inputPassword,
          isValid: inputIsValid,
        );

  @override
  List<Object?> get props => [
        inputEmail,
        inputPassword,
        inputIsValid,
      ];
}
