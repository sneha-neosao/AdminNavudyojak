part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class GetNotificationsEvent extends NotificationsEvent {
  final int page;
  final int limit;

  const GetNotificationsEvent({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

class LoadMoreNotificationsEvent extends NotificationsEvent {
  const LoadMoreNotificationsEvent();
}

class RefreshNotificationsEvent extends NotificationsEvent {
  const RefreshNotificationsEvent();
}
