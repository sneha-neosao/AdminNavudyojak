part of 'customer_details_bloc.dart';

sealed class CustomerDetailsEvent extends Equatable {
  const CustomerDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetCustomerDetailsEvent extends CustomerDetailsEvent {
  final String id;

  const GetCustomerDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshCustomerDetailsEvent extends CustomerDetailsEvent {
  final String id;

  const RefreshCustomerDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}
