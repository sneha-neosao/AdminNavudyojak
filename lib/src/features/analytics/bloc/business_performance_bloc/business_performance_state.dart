part of 'business_performance_bloc.dart';

sealed class BusinessPerformanceState extends Equatable {
  const BusinessPerformanceState();

  @override
  List<Object?> get props => [];
}

class BusinessPerformanceInitialState extends BusinessPerformanceState {}

class BusinessPerformanceLoadingState extends BusinessPerformanceState {}

class BusinessPerformanceSuccessState extends BusinessPerformanceState {
  final BusinessPerformanceResponse data;

  const BusinessPerformanceSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class BusinessPerformanceFailureState extends BusinessPerformanceState {
  final String message;

  const BusinessPerformanceFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
