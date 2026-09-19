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
  final String? dateFrom;
  final String? dateTo;
  final String? isDashboard;
  final String? ordering;
  final String? refundType;

  const GetRefundsEvent({
    this.page = 1,
    this.limit = 10,
    this.status,
    this.search,
    this.dateFrom,
    this.dateTo,
    this.isDashboard,
    this.ordering,
    this.refundType,
  });

  @override
  List<Object?> get props => [
        page,
        limit,
        status,
        search,
        dateFrom,
        dateTo,
        isDashboard,
        ordering,
        refundType,
      ];
}

class LoadMoreRefundsEvent extends RefundsEvent {}

class RefreshRefundsEvent extends RefundsEvent {}

class FilterRefundsByStatusEvent extends RefundsEvent {
  final String? status;

  const FilterRefundsByStatusEvent({this.status});

  @override
  List<Object?> get props => [status];
}
