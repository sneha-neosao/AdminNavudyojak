part of 'customers_bloc.dart';

sealed class CustomersEvent extends Equatable {
  const CustomersEvent();

  @override
  List<Object?> get props => [];
}

class GetCustomersEvent extends CustomersEvent {
  final int page;
  final int limit;
  final String? search;
  final String? city;
  final String? state;
  final String? isActive;

  const GetCustomersEvent({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.city,
    this.state,
    this.isActive,
  });

  @override
  List<Object?> get props => [page, limit, search, city, state, isActive];
}

class LoadMoreCustomersEvent extends CustomersEvent {}

class RefreshCustomersEvent extends CustomersEvent {}
