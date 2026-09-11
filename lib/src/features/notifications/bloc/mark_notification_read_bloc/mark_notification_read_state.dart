part of 'mark_notification_read_bloc.dart';

sealed class MarkNotificationReadState extends Equatable {
  const MarkNotificationReadState();

  @override
  List<Object?> get props => [];
}

class MarkNotificationReadInitialState extends MarkNotificationReadState {}

class MarkNotificationReadLoadingState extends MarkNotificationReadState {
  final String notificationId;

  const MarkNotificationReadLoadingState(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkNotificationReadSuccessState extends MarkNotificationReadState {
  final MarkNotificationReadResponse data;
  final String notificationId;

  const MarkNotificationReadSuccessState(this.data, this.notificationId);

  @override
  List<Object?> get props => [data, notificationId];
}

class MarkNotificationReadFailureState extends MarkNotificationReadState {
  final String message;
  final String notificationId;

  const MarkNotificationReadFailureState(this.message, this.notificationId);

  @override
  List<Object?> get props => [message, notificationId];
}
