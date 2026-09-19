part of 'refunds_bloc.dart';

sealed class RefundsState extends Equatable {
  const RefundsState();

  @override
  List<Object?> get props => [];
}

class RefundsInitialState extends RefundsState {}

class RefundsLoadingState extends RefundsState {}

class RefundsSuccessState extends RefundsState {
  final RefundsResponse data;
  final List<RefundItem> allResults;
  final bool hasReachedMax;
  final bool isLoadingMore;

  RefundsSuccessState(
    this.data, {
    List<RefundItem>? allResults,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  }) : allResults = allResults ??
            (data.data?.items.isNotEmpty == true
                ? data.data!.items
                : (data.data?.results ?? const []));

  RefundMetrics? get metrics => data.data?.metrics;

  RefundsSuccessState copyWith({
    RefundsResponse? data,
    List<RefundItem>? allResults,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return RefundsSuccessState(
      data ?? this.data,
      allResults: allResults ?? this.allResults,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [data, allResults, hasReachedMax, isLoadingMore];
}

class RefundsFailureState extends RefundsState {
  final String message;

  const RefundsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
