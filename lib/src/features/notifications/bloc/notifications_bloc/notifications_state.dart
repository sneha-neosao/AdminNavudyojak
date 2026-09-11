part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitialState extends NotificationsState {}

class NotificationsLoadingState extends NotificationsState {}

class NotificationsSuccessState extends NotificationsState {
  final NotificationsResponse data;
  final List<NotificationModel> allResults;
  final bool hasReachedMax;
  final bool isLoadingMore;

  NotificationsSuccessState(
    this.data, {
    List<NotificationModel>? allResults,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  }) : allResults = allResults ?? data.data?.results ?? const [];

  NotificationsSuccessState copyWith({
    NotificationsResponse? data,
    List<NotificationModel>? allResults,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return NotificationsSuccessState(
      data ?? this.data,
      allResults: allResults ?? this.allResults,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [data, allResults, hasReachedMax, isLoadingMore];
}

class NotificationsFailureState extends NotificationsState {
  final String message;

  const NotificationsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
