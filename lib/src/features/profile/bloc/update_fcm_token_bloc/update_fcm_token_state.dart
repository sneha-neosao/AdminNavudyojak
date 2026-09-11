part of 'update_fcm_token_bloc.dart';

sealed class UpdateFcmTokenState extends Equatable {
  const UpdateFcmTokenState();

  @override
  List<Object?> get props => [];
}

class UpdateFcmTokenInitialState extends UpdateFcmTokenState {}

class UpdateFcmTokenLoadingState extends UpdateFcmTokenState {}

class UpdateFcmTokenSuccessState extends UpdateFcmTokenState {
  final UpdateFcmTokenResponse data;

  const UpdateFcmTokenSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateFcmTokenFailureState extends UpdateFcmTokenState {
  final String message;

  const UpdateFcmTokenFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
