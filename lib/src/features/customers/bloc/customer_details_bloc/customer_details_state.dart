part of 'customer_details_bloc.dart';

sealed class CustomerDetailsState extends Equatable {
  const CustomerDetailsState();

  @override
  List<Object?> get props => [];
}

class CustomerDetailsInitialState extends CustomerDetailsState {}

class CustomerDetailsLoadingState extends CustomerDetailsState {}

class CustomerDetailsSuccessState extends CustomerDetailsState {
  final CustomerDetailsResponse data;

  const CustomerDetailsSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class CustomerDetailsFailureState extends CustomerDetailsState {
  final String message;

  const CustomerDetailsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
