part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SubmitResetPasswordEvent extends ResetPasswordEvent {
  final String token;
  final String password;
  final String passwordConfirm;

  const SubmitResetPasswordEvent({
    required this.token,
    required this.password,
    required this.passwordConfirm,
  });

  @override
  List<Object?> get props => [token, password, passwordConfirm];
}
