part of 'mark_notification_read_bloc.dart';

sealed class MarkNotificationReadEvent extends Equatable {
  const MarkNotificationReadEvent();

  @override
  List<Object?> get props => [];
}

class ExecuteMarkNotificationReadEvent extends MarkNotificationReadEvent {
  final String notificationId;

  const ExecuteMarkNotificationReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
