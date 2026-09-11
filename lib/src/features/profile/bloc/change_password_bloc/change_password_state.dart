part of 'change_password_bloc.dart';

sealed class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object?> get props => [];
}

class ChangePasswordInitialState extends ChangePasswordState {}

class ChangePasswordLoadingState extends ChangePasswordState {}

class ChangePasswordSuccessState extends ChangePasswordState {
  final ChangePasswordResponse data;

  const ChangePasswordSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class ChangePasswordFailureState extends ChangePasswordState {
  final String message;

  const ChangePasswordFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
