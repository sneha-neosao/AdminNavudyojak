import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecase/approve_pending_advance_usecase.dart';
import '../../../../remote/models/bookings_model/approve_pending_advance_response.dart';

part 'approve_pending_advance_event.dart';
part 'approve_pending_advance_state.dart';

class ApprovePendingAdvanceBloc
    extends Bloc<ApprovePendingAdvanceEvent, ApprovePendingAdvanceState> {
  final ApprovePendingAdvanceUseCase _approvePendingAdvanceUseCase;

  ApprovePendingAdvanceBloc(
    this._approvePendingAdvanceUseCase,
  ) : super(ApprovePendingAdvanceInitialState()) {
    on<ApprovePendingAdvanceSubmitEvent>(_approvePendingAdvance);
  }

  Future<void> _approvePendingAdvance(
    ApprovePendingAdvanceSubmitEvent event,
    Emitter<ApprovePendingAdvanceState> emit,
  ) async {
    emit(ApprovePendingAdvanceLoadingState(event.bookingId));

    final result = await _approvePendingAdvanceUseCase.call(event.bookingId);

    result.fold(
      (failure) => emit(
        ApprovePendingAdvanceFailureState(failure.message, event.bookingId),
      ),
      (data) => emit(
        ApprovePendingAdvanceSuccessState(data, event.bookingId),
      ),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE ApprovePendingAdvanceBloc =====");
    return super.close();
  }
}
