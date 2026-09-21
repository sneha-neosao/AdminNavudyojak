part of 'pending_advance_bookings_bloc.dart';

sealed class PendingAdvanceBookingsEvent extends Equatable {
  const PendingAdvanceBookingsEvent();

  @override
  List<Object?> get props => [];
}

class GetPendingAdvanceBookingsEvent extends PendingAdvanceBookingsEvent {
  final int page;
  final int limit;
  final String? search;

  const GetPendingAdvanceBookingsEvent({
    this.page = 1,
    this.limit = 10,
    this.search,
  });

  @override
  List<Object?> get props => [page, limit, search];
}

class LoadMorePendingAdvanceBookingsEvent extends PendingAdvanceBookingsEvent {}

class RefreshPendingAdvanceBookingsEvent extends PendingAdvanceBookingsEvent {}
