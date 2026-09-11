import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecase/notifications_usecase.dart';
import '../../../../remote/models/notifications_model/notifications_response.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsUseCase _notificationsUseCase;

  int _currentPage = 1;
  String _currentStatus = 'all';
  static const int _limit = 10;

  NotificationsBloc(this._notificationsUseCase)
      : super(NotificationsInitialState()) {
    on<GetNotificationsEvent>(_getNotifications);
    on<FilterNotificationsEvent>(_filterNotifications);
    on<LoadMoreNotificationsEvent>(_loadMoreNotifications);
    on<RefreshNotificationsEvent>(_refreshNotifications);
  }

  Future<void> _getNotifications(
    GetNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    _currentPage = event.page;
    _currentStatus = event.status;
    emit(NotificationsLoadingState());

    final result = await _notificationsUseCase.call(
      NotificationsParams(
        page: _currentPage,
        limit: event.limit,
        status: _currentStatus,
      ),
    );

    result.fold(
      (failure) => emit(NotificationsFailureState(failure.message)),
      (data) {
        final results = data.data?.results ?? [];
        final totalPages = data.data?.pagination?.totalPages ?? 1;
        final hasReachedMax =
            _currentPage >= totalPages || results.length < event.limit;

        emit(NotificationsSuccessState(
          data,
          allResults: results,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _filterNotifications(
    FilterNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    _currentPage = 1;
    _currentStatus = event.status;
    emit(NotificationsLoadingState());

    final result = await _notificationsUseCase.call(
      NotificationsParams(
        page: 1,
        limit: _limit,
        status: _currentStatus,
      ),
    );

    result.fold(
      (failure) => emit(NotificationsFailureState(failure.message)),
      (data) {
        final results = data.data?.results ?? [];
        final totalPages = data.data?.pagination?.totalPages ?? 1;
        final hasReachedMax = 1 >= totalPages || results.length < _limit;

        emit(NotificationsSuccessState(
          data,
          allResults: results,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _loadMoreNotifications(
    LoadMoreNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is! NotificationsSuccessState) return;

    final currentSuccess = state as NotificationsSuccessState;
    if (currentSuccess.hasReachedMax || currentSuccess.isLoadingMore) return;

    emit(currentSuccess.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;

    final result = await _notificationsUseCase.call(
      NotificationsParams(
        page: nextPage,
        limit: _limit,
        status: _currentStatus,
      ),
    );

    result.fold(
      (failure) {
        emit(currentSuccess.copyWith(isLoadingMore: false));
      },
      (data) {
        _currentPage = nextPage;
        final newItems = data.data?.results ?? [];
        final combined = [...currentSuccess.allResults, ...newItems];
        final totalPages = data.data?.pagination?.totalPages ?? nextPage;
        final hasReachedMax = _currentPage >= totalPages || newItems.isEmpty;

        emit(currentSuccess.copyWith(
          data: data,
          allResults: combined,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _refreshNotifications(
    RefreshNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    _currentPage = 1;

    final result = await _notificationsUseCase.call(
      NotificationsParams(
        page: 1,
        limit: _limit,
        status: _currentStatus,
      ),
    );

    result.fold(
      (failure) => emit(NotificationsFailureState(failure.message)),
      (data) {
        final results = data.data?.results ?? [];
        final totalPages = data.data?.pagination?.totalPages ?? 1;
        final hasReachedMax = 1 >= totalPages || results.length < _limit;

        emit(NotificationsSuccessState(
          data,
          allResults: results,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE NotificationsBloc =====");
    return super.close();
  }
}
