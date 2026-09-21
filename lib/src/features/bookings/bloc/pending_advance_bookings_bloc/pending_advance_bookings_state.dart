part of 'pending_advance_bookings_bloc.dart';

sealed class PendingAdvanceBookingsState extends Equatable {
  const PendingAdvanceBookingsState();

  @override
  List<Object?> get props => [];
}

class PendingAdvanceBookingsInitialState extends PendingAdvanceBookingsState {}

class PendingAdvanceBookingsLoadingState extends PendingAdvanceBookingsState {}

class PendingAdvanceBookingsSuccessState extends PendingAdvanceBookingsState {
  final PendingAdvanceBookingsResponse data;
  final List<PendingAdvanceBookingItem> allResults;
  final bool hasReachedMax;
  final bool isLoadingMore;

  PendingAdvanceBookingsSuccessState(
    this.data, {
    List<PendingAdvanceBookingItem>? allResults,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  }) : allResults = allResults ??
            (data.data?.results.isNotEmpty == true
                ? data.data!.results
                : (data.data?.items ?? const []));

  PendingAdvancePagination? get pagination => data.data?.pagination;

  PendingAdvanceBookingsSuccessState copyWith({
    PendingAdvanceBookingsResponse? data,
    List<PendingAdvanceBookingItem>? allResults,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return PendingAdvanceBookingsSuccessState(
      data ?? this.data,
      allResults: allResults ?? this.allResults,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [data, allResults, hasReachedMax, isLoadingMore];
}

class PendingAdvanceBookingsFailureState extends PendingAdvanceBookingsState {
  final String message;

  const PendingAdvanceBookingsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
