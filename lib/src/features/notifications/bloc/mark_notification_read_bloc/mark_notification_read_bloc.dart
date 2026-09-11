import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../remote/models/notifications_model/mark_notification_read_response.dart';
import '../../domain/usecase/mark_notification_read_usecase.dart';

part 'mark_notification_read_event.dart';
part 'mark_notification_read_state.dart';

/// Handles state management for marking a single notification as read adhering to Rule 4.1.
class MarkNotificationReadBloc
    extends Bloc<MarkNotificationReadEvent, MarkNotificationReadState> {
  final MarkNotificationReadUseCase _markNotificationReadUseCase;

  MarkNotificationReadBloc(this._markNotificationReadUseCase)
      : super(MarkNotificationReadInitialState()) {
    on<ExecuteMarkNotificationReadEvent>(_onMarkAsRead);
  }

  Future<void> _onMarkAsRead(
    ExecuteMarkNotificationReadEvent event,
    Emitter<MarkNotificationReadState> emit,
  ) async {
    emit(MarkNotificationReadLoadingState(event.notificationId));

    final result =
        await _markNotificationReadUseCase.call(event.notificationId);

    result.fold(
      (failure) => emit(
        MarkNotificationReadFailureState(failure.message, event.notificationId),
      ),
      (data) => emit(
        MarkNotificationReadSuccessState(data, event.notificationId),
      ),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE MarkNotificationReadBloc =====");
    return super.close();
  }
}
