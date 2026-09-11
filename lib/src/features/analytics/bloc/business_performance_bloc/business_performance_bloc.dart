import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../../../remote/models/analytics_model/business_performance_response.dart';
import '../../domain/usecase/business_performance_usecase.dart';

part 'business_performance_event.dart';
part 'business_performance_state.dart';

/// Handles state management for **Business Performance Analytics** adhering to Rule 4.1.
class BusinessPerformanceBloc
    extends Bloc<BusinessPerformanceEvent, BusinessPerformanceState> {
  final BusinessPerformanceUseCase _businessPerformanceUseCase;

  BusinessPerformanceBloc(this._businessPerformanceUseCase)
      : super(BusinessPerformanceInitialState()) {
    on<GetBusinessPerformanceEvent>(_onGetBusinessPerformance);
    on<RefreshBusinessPerformanceEvent>(_onRefreshBusinessPerformance);
  }

  Future<void> _onGetBusinessPerformance(
    GetBusinessPerformanceEvent event,
    Emitter<BusinessPerformanceState> emit,
  ) async {
    emit(BusinessPerformanceLoadingState());

    final result = await _businessPerformanceUseCase.call(NoParams());

    result.fold(
      (failure) => emit(BusinessPerformanceFailureState(failure.message)),
      (data) => emit(BusinessPerformanceSuccessState(data)),
    );
  }

  Future<void> _onRefreshBusinessPerformance(
    RefreshBusinessPerformanceEvent event,
    Emitter<BusinessPerformanceState> emit,
  ) async {
    final result = await _businessPerformanceUseCase.call(NoParams());

    result.fold(
      (failure) => emit(BusinessPerformanceFailureState(failure.message)),
      (data) => emit(BusinessPerformanceSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE BusinessPerformanceBloc =====");
    return super.close();
  }
}
