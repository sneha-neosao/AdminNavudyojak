part of 'verify_reset_token_bloc.dart';

sealed class VerifyResetTokenEvent extends Equatable {
  const VerifyResetTokenEvent();

  @override
  List<Object?> get props => [];
}

class VerifyResetTokenSubmitEvent extends VerifyResetTokenEvent {
  final String token;

  const VerifyResetTokenSubmitEvent(this.token);

  @override
  List<Object?> get props => [token];
}
