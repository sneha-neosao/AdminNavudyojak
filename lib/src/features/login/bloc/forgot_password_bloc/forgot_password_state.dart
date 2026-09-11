part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitialState extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordSuccessState extends ForgotPasswordState {
  final ForgotPasswordResponse data;

  const ForgotPasswordSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ForgotPasswordFailureState extends ForgotPasswordState {
  final String message;

  const ForgotPasswordFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
