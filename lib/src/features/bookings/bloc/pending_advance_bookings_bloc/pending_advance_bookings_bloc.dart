import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecase/pending_advance_bookings_usecase.dart';
import '../../../../remote/models/bookings_model/pending_advance_bookings_response.dart';

part 'pending_advance_bookings_event.dart';
part 'pending_advance_bookings_state.dart';

class PendingAdvanceBookingsBloc
    extends Bloc<PendingAdvanceBookingsEvent, PendingAdvanceBookingsState> {
  final PendingAdvanceBookingsUseCase _pendingAdvanceBookingsUseCase;

  int _currentPage = 1;
  static const int _limit = 10;
  String? _currentSearch;

  PendingAdvanceBookingsBloc(this._pendingAdvanceBookingsUseCase)
      : super(PendingAdvanceBookingsInitialState()) {
    on<GetPendingAdvanceBookingsEvent>(_getPendingAdvanceBookings);
    on<LoadMorePendingAdvanceBookingsEvent>(_loadMorePendingAdvanceBookings);
    on<RefreshPendingAdvanceBookingsEvent>(_refreshPendingAdvanceBookings);
  }

  Future<void> _getPendingAdvanceBookings(
    GetPendingAdvanceBookingsEvent event,
    Emitter<PendingAdvanceBookingsState> emit,
  ) async {
    _currentPage = event.page;
    _currentSearch = event.search;

    emit(PendingAdvanceBookingsLoadingState());

    final result = await _pendingAdvanceBookingsUseCase.call(
      PendingAdvanceBookingsParams(
        page: _currentPage,
        limit: event.limit,
        search: _currentSearch,
      ),
    );

    result.fold(
      (failure) => emit(PendingAdvanceBookingsFailureState(failure.message)),
      (data) {
        final results = data.data?.results.isNotEmpty == true
            ? data.data!.results
            : (data.data?.items ?? []);
        final totalCount = data.data?.pagination?.count ?? results.length;
        final totalPages = data.data?.pagination?.totalPages ??
            (totalCount > 0 ? (totalCount / event.limit).ceil() : 1);
        final hasReachedMax =
            _currentPage >= totalPages || results.length < event.limit;

        emit(PendingAdvanceBookingsSuccessState(
          data,
          allResults: results,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _loadMorePendingAdvanceBookings(
    LoadMorePendingAdvanceBookingsEvent event,
    Emitter<PendingAdvanceBookingsState> emit,
  ) async {
    if (state is! PendingAdvanceBookingsSuccessState) return;

    final currentSuccess = state as PendingAdvanceBookingsSuccessState;
    if (currentSuccess.hasReachedMax || currentSuccess.isLoadingMore) return;

    emit(currentSuccess.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;

    final result = await _pendingAdvanceBookingsUseCase.call(
      PendingAdvanceBookingsParams(
        page: nextPage,
        limit: _limit,
        search: _currentSearch,
      ),
    );

    result.fold(
      (failure) {
        emit(currentSuccess.copyWith(isLoadingMore: false));
      },
      (data) {
        final newResults = data.data?.results.isNotEmpty == true
            ? data.data!.results
            : (data.data?.items ?? []);
        _currentPage = nextPage;

        final combinedResults = List<PendingAdvanceBookingItem>.from(
          currentSuccess.allResults,
        )..addAll(newResults);

        final totalCount =
            data.data?.pagination?.count ?? combinedResults.length;
        final totalPages = data.data?.pagination?.totalPages ??
            (totalCount > 0 ? (totalCount / _limit).ceil() : 1);
        final hasReachedMax =
            _currentPage >= totalPages || newResults.length < _limit;

        emit(currentSuccess.copyWith(
          data: data,
          allResults: combinedResults,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _refreshPendingAdvanceBookings(
    RefreshPendingAdvanceBookingsEvent event,
    Emitter<PendingAdvanceBookingsState> emit,
  ) async {
    _currentPage = 1;

    final result = await _pendingAdvanceBookingsUseCase.call(
      PendingAdvanceBookingsParams(
        page: 1,
        limit: _limit,
        search: _currentSearch,
      ),
    );

    result.fold(
      (failure) => emit(PendingAdvanceBookingsFailureState(failure.message)),
      (data) {
        final results = data.data?.results.isNotEmpty == true
            ? data.data!.results
            : (data.data?.items ?? []);
        final totalCount = data.data?.pagination?.count ?? results.length;
        final totalPages = data.data?.pagination?.totalPages ??
            (totalCount > 0 ? (totalCount / _limit).ceil() : 1);
        final hasReachedMax =
            _currentPage >= totalPages || results.length < _limit;

        emit(PendingAdvanceBookingsSuccessState(
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
    logger.i("===== CLOSE PendingAdvanceBookingsBloc =====");
    return super.close();
  }
}
