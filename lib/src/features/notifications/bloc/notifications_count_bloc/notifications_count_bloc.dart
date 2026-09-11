import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../../../remote/models/notifications_model/notifications_count_response.dart';
import '../../domain/usecase/notifications_count_usecase.dart';

part 'notifications_count_event.dart';
part 'notifications_count_state.dart';

/// Handles state management for **Notifications Count** adhering to Rule 4.1.
class NotificationsCountBloc
    extends Bloc<NotificationsCountEvent, NotificationsCountState> {
  final NotificationsCountUseCase _notificationsCountUseCase;

  NotificationsCountBloc(this._notificationsCountUseCase)
      : super(NotificationsCountInitialState()) {
    on<GetNotificationsCountEvent>(_getNotificationsCount);
    on<RefreshNotificationsCountEvent>(_refreshNotificationsCount);
  }

  Future<void> _getNotificationsCount(
    GetNotificationsCountEvent event,
    Emitter<NotificationsCountState> emit,
  ) async {
    emit(NotificationsCountLoadingState());

    final result = await _notificationsCountUseCase.call(NoParams());

    result.fold(
      (failure) => emit(NotificationsCountFailureState(failure.message)),
      (data) => emit(NotificationsCountSuccessState(data)),
    );
  }

  Future<void> _refreshNotificationsCount(
    RefreshNotificationsCountEvent event,
    Emitter<NotificationsCountState> emit,
  ) async {
    final result = await _notificationsCountUseCase.call(NoParams());

    result.fold(
      (failure) => emit(NotificationsCountFailureState(failure.message)),
      (data) => emit(NotificationsCountSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE NotificationsCountBloc =====");
    return super.close();
  }
}
