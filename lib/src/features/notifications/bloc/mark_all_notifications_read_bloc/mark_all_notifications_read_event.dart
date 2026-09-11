part of 'mark_all_notifications_read_bloc.dart';

sealed class MarkAllNotificationsReadEvent extends Equatable {
  const MarkAllNotificationsReadEvent();

  @override
  List<Object?> get props => [];
}

class ExecuteMarkAllNotificationsReadEvent
    extends MarkAllNotificationsReadEvent {}
