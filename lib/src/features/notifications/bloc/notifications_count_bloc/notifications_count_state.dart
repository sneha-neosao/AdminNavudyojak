part of 'notifications_count_bloc.dart';

sealed class NotificationsCountState extends Equatable {
  const NotificationsCountState();

  @override
  List<Object?> get props => [];
}

class NotificationsCountInitialState extends NotificationsCountState {}

class NotificationsCountLoadingState extends NotificationsCountState {}

class NotificationsCountSuccessState extends NotificationsCountState {
  final NotificationsCountResponse data;

  const NotificationsCountSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class NotificationsCountFailureState extends NotificationsCountState {
  final String message;

  const NotificationsCountFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
