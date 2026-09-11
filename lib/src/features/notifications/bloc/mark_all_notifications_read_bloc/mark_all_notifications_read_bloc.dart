import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../../../remote/models/notifications_model/mark_all_read_response.dart';
import '../../domain/usecase/mark_all_notifications_read_usecase.dart';

part 'mark_all_notifications_read_event.dart';
part 'mark_all_notifications_read_state.dart';

/// Handles state management for marking all notifications as read adhering to Rule 4.1.
class MarkAllNotificationsReadBloc
    extends Bloc<MarkAllNotificationsReadEvent, MarkAllNotificationsReadState> {
  final MarkAllNotificationsReadUseCase _markAllNotificationsReadUseCase;

  MarkAllNotificationsReadBloc(this._markAllNotificationsReadUseCase)
      : super(MarkAllNotificationsReadInitialState()) {
    on<ExecuteMarkAllNotificationsReadEvent>(_onMarkAllAsRead);
  }

  Future<void> _onMarkAllAsRead(
    ExecuteMarkAllNotificationsReadEvent event,
    Emitter<MarkAllNotificationsReadState> emit,
  ) async {
    emit(MarkAllNotificationsReadLoadingState());

    final result = await _markAllNotificationsReadUseCase.call(NoParams());

    result.fold(
      (failure) => emit(MarkAllNotificationsReadFailureState(failure.message)),
      (data) => emit(MarkAllNotificationsReadSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE MarkAllNotificationsReadBloc =====");
    return super.close();
  }
}
