import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/logger.dart';
import '../../../../remote/models/dashboard_model/admin_dashboard_response.dart';
import '../../domain/usecase/admin_dashboard_usecase.dart';

part 'admin_dashboard_event.dart';
part 'admin_dashboard_state.dart';

/// Handles state management for **Admin Dashboard** adhering to Rule 4.1.
class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final AdminDashboardUseCase _adminDashboardUseCase;
  String _currentPeriod = 'this_week';

  AdminDashboardBloc(this._adminDashboardUseCase)
    : super(AdminDashboardInitialState()) {
    on<GetAdminDashboardEvent>(_onGetAdminDashboard);
    on<ChangePeriodEvent>(_onChangePeriod);
    on<RefreshAdminDashboardEvent>(_onRefreshAdminDashboard);
  }

  Future<void> _onGetAdminDashboard(
    GetAdminDashboardEvent event,
    Emitter<AdminDashboardState> emit,
  ) async {
    _currentPeriod = event.period;
    emit(AdminDashboardLoadingState());

    final result = await _adminDashboardUseCase.call(
      AdminDashboardParams(period: _currentPeriod),
    );

    result.fold(
      (failure) => emit(AdminDashboardFailureState(failure.message)),
      (data) => emit(
        AdminDashboardSuccessState(
          data,
          isChangingPeriod: false,
          currentPeriod: _currentPeriod,
        ),
      ),
    );
  }

  Future<void> _onChangePeriod(
    ChangePeriodEvent event,
    Emitter<AdminDashboardState> emit,
  ) async {
    _currentPeriod = event.period;

    if (state is AdminDashboardSuccessState) {
      final currentSuccess = state as AdminDashboardSuccessState;
      emit(
        currentSuccess.copyWith(
          isChangingPeriod: true,
          currentPeriod: _currentPeriod,
        ),
      );
    } else {
      emit(AdminDashboardLoadingState());
    }

    final result = await _adminDashboardUseCase.call(
      AdminDashboardParams(period: _currentPeriod),
    );

    result.fold(
      (failure) {
        if (state is AdminDashboardSuccessState) {
          final currentSuccess = state as AdminDashboardSuccessState;
          emit(currentSuccess.copyWith(isChangingPeriod: false));
        } else {
          emit(AdminDashboardFailureState(failure.message));
        }
      },
      (data) => emit(
        AdminDashboardSuccessState(
          data,
          isChangingPeriod: false,
          currentPeriod: _currentPeriod,
        ),
      ),
    );
  }

  Future<void> _onRefreshAdminDashboard(
    RefreshAdminDashboardEvent event,
    Emitter<AdminDashboardState> emit,
  ) async {
    final result = await _adminDashboardUseCase.call(
      AdminDashboardParams(period: _currentPeriod),
    );

    result.fold(
      (failure) => emit(AdminDashboardFailureState(failure.message)),
      (data) => emit(
        AdminDashboardSuccessState(
          data,
          isChangingPeriod: false,
          currentPeriod: _currentPeriod,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE AdminDashboardBloc =====");
    return super.close();
  }
}
