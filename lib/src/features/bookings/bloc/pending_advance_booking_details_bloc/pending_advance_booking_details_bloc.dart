import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecase/pending_advance_booking_details_usecase.dart';
import '../../../../remote/models/bookings_model/pending_advance_booking_details_response.dart';

part 'pending_advance_booking_details_event.dart';
part 'pending_advance_booking_details_state.dart';

class PendingAdvanceBookingDetailsBloc
    extends
        Bloc<PendingAdvanceBookingDetailsEvent,
            PendingAdvanceBookingDetailsState> {
  final PendingAdvanceBookingDetailsUseCase
      _pendingAdvanceBookingDetailsUseCase;

  PendingAdvanceBookingDetailsBloc(
    this._pendingAdvanceBookingDetailsUseCase,
  ) : super(PendingAdvanceBookingDetailsInitialState()) {
    on<GetPendingAdvanceBookingDetailsEvent>(_getPendingAdvanceBookingDetails);
    on<RefreshPendingAdvanceBookingDetailsEvent>(
      _refreshPendingAdvanceBookingDetails,
    );
  }

  Future<void> _getPendingAdvanceBookingDetails(
    GetPendingAdvanceBookingDetailsEvent event,
    Emitter<PendingAdvanceBookingDetailsState> emit,
  ) async {
    emit(PendingAdvanceBookingDetailsLoadingState());

    final result = await _pendingAdvanceBookingDetailsUseCase.call(event.id);

    result.fold(
      (failure) =>
          emit(PendingAdvanceBookingDetailsFailureState(failure.message)),
      (data) => emit(PendingAdvanceBookingDetailsSuccessState(data)),
    );
  }

  Future<void> _refreshPendingAdvanceBookingDetails(
    RefreshPendingAdvanceBookingDetailsEvent event,
    Emitter<PendingAdvanceBookingDetailsState> emit,
  ) async {
    final result = await _pendingAdvanceBookingDetailsUseCase.call(event.id);

    result.fold(
      (failure) =>
          emit(PendingAdvanceBookingDetailsFailureState(failure.message)),
      (data) => emit(PendingAdvanceBookingDetailsSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE PendingAdvanceBookingDetailsBloc =====");
    return super.close();
  }
}
