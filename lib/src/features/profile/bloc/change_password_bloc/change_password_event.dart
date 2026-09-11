part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object?> get props => [];
}

class SubmitChangePasswordEvent extends ChangePasswordEvent {
  final String userId;
  final String password;
  final String passwordConfirm;

  const SubmitChangePasswordEvent({
    required this.userId,
    required this.password,
    required this.passwordConfirm,
  });

  @override
  List<Object?> get props => [userId, password, passwordConfirm];
}

class ResetChangePasswordEvent extends ChangePasswordEvent {}
