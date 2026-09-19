part of 'refunds_bloc.dart';

sealed class RefundsEvent extends Equatable {
  const RefundsEvent();

  @override
  List<Object?> get props => [];
}

class GetRefundsEvent extends RefundsEvent {
  final int page;
  final int limit;
  final String? status;
  final String? search;

  const GetRefundsEvent({
    this.page = 1,
    this.limit = 10,
    this.status,
    this.search,
  });

  @override
  List<Object?> get props => [page, limit, status, search];
}

class LoadMoreRefundsEvent extends RefundsEvent {}

class RefreshRefundsEvent extends RefundsEvent {}

class FilterRefundsByStatusEvent extends RefundsEvent {
  final String? status;

  const FilterRefundsByStatusEvent({this.status});

  @override
  List<Object?> get props => [status];
}
