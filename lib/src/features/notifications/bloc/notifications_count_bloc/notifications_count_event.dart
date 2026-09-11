part of 'notifications_count_bloc.dart';

sealed class NotificationsCountEvent extends Equatable {
  const NotificationsCountEvent();

  @override
  List<Object?> get props => [];
}

class GetNotificationsCountEvent extends NotificationsCountEvent {
  const GetNotificationsCountEvent();
}

class RefreshNotificationsCountEvent extends NotificationsCountEvent {
  const RefreshNotificationsCountEvent();
}
