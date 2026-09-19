part of 'reset_password_bloc.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitialState extends ResetPasswordState {}

class ResetPasswordLoadingState extends ResetPasswordState {}

class ResetPasswordSuccessState extends ResetPasswordState {
  final ResetPasswordResponse data;

  const ResetPasswordSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ResetPasswordFailureState extends ResetPasswordState {
  final String message;

  const ResetPasswordFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
