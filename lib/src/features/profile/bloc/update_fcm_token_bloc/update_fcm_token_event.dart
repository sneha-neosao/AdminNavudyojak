part of 'update_fcm_token_bloc.dart';

sealed class UpdateFcmTokenEvent extends Equatable {
  const UpdateFcmTokenEvent();

  @override
  List<Object?> get props => [];
}

class SubmitUpdateFcmTokenEvent extends UpdateFcmTokenEvent {
  final String fcmToken;

  const SubmitUpdateFcmTokenEvent(this.fcmToken);

  @override
  List<Object?> get props => [fcmToken];
}
