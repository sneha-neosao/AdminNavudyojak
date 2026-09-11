part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class GetNotificationsEvent extends NotificationsEvent {
  final int page;
  final int limit;
  final String status;

  const GetNotificationsEvent({
    this.page = 1,
    this.limit = 10,
    this.status = 'all',
  });

  @override
  List<Object?> get props => [page, limit, status];
}

class FilterNotificationsEvent extends NotificationsEvent {
  final String status;

  const FilterNotificationsEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class LoadMoreNotificationsEvent extends NotificationsEvent {
  const LoadMoreNotificationsEvent();
}

class RefreshNotificationsEvent extends NotificationsEvent {
  const RefreshNotificationsEvent();
}
