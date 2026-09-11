part of 'customers_bloc.dart';

sealed class CustomersState extends Equatable {
  const CustomersState();

  @override
  List<Object?> get props => [];
}

class CustomersInitialState extends CustomersState {}

class CustomersLoadingState extends CustomersState {}

class CustomersSuccessState extends CustomersState {
  final CustomersResponse data;
  final List<CustomerItem> allResults;
  final bool hasReachedMax;
  final bool isLoadingMore;

  CustomersSuccessState(
    this.data, {
    List<CustomerItem>? allResults,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  }) : allResults = allResults ?? data.data?.results ?? const [];

  CustomersSuccessState copyWith({
    CustomersResponse? data,
    List<CustomerItem>? allResults,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return CustomersSuccessState(
      data ?? this.data,
      allResults: allResults ?? this.allResults,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [data, allResults, hasReachedMax, isLoadingMore];
}

class CustomersFailureState extends CustomersState {
  final String message;

  const CustomersFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
