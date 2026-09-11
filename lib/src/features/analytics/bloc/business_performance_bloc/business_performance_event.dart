part of 'business_performance_bloc.dart';

sealed class BusinessPerformanceEvent extends Equatable {
  const BusinessPerformanceEvent();

  @override
  List<Object?> get props => [];
}

class GetBusinessPerformanceEvent extends BusinessPerformanceEvent {
  const GetBusinessPerformanceEvent();
}

class RefreshBusinessPerformanceEvent extends BusinessPerformanceEvent {
  const RefreshBusinessPerformanceEvent();
}
