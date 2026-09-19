part of 'verify_reset_token_bloc.dart';

sealed class VerifyResetTokenState extends Equatable {
  const VerifyResetTokenState();

  @override
  List<Object?> get props => [];
}

class VerifyResetTokenInitialState extends VerifyResetTokenState {}

class VerifyResetTokenLoadingState extends VerifyResetTokenState {}

class VerifyResetTokenSuccessState extends VerifyResetTokenState {
  final VerifyResetTokenResponse data;

  const VerifyResetTokenSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class VerifyResetTokenFailureState extends VerifyResetTokenState {
  final String message;

  const VerifyResetTokenFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
