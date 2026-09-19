import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecase/refunds_usecase.dart';
import '../../../../remote/models/request_model/refunds_response.dart';

part 'refunds_event.dart';
part 'refunds_state.dart';

class RefundsBloc extends Bloc<RefundsEvent, RefundsState> {
  final RefundsUseCase _refundsUseCase;

  int _currentPage = 1;
  static const int _limit = 10;
  String? _currentStatus;
  String? _currentSearch;
  String? _currentDateFrom;
  String? _currentDateTo;
  String? _currentIsDashboard;
  String? _currentOrdering;
  String? _currentRefundType;

  RefundsBloc(this._refundsUseCase) : super(RefundsInitialState()) {
    on<GetRefundsEvent>(_getRefunds);
    on<LoadMoreRefundsEvent>(_loadMoreRefunds);
    on<RefreshRefundsEvent>(_refreshRefunds);
    on<FilterRefundsByStatusEvent>(_filterByStatus);
  }

  Future<void> _getRefunds(
    GetRefundsEvent event,
    Emitter<RefundsState> emit,
  ) async {
    _currentPage = event.page;
    _currentStatus = event.status;
    _currentSearch = event.search;
    _currentDateFrom = event.dateFrom;
    _currentDateTo = event.dateTo;
    _currentIsDashboard = event.isDashboard;
    _currentOrdering = event.ordering;
    _currentRefundType = event.refundType;

    emit(RefundsLoadingState());

    final result = await _refundsUseCase.call(
      RefundsParams(
        page: _currentPage,
        limit: event.limit,
        status: _currentStatus,
        search: _currentSearch,
        dateFrom: _currentDateFrom,
        dateTo: _currentDateTo,
        isDashboard: _currentIsDashboard,
        ordering: _currentOrdering,
        refundType: _currentRefundType,
      ),
    );

    result.fold(
      (failure) => emit(RefundsFailureState(failure.message)),
      (data) {
        final results = data.data?.items.isNotEmpty == true
            ? data.data!.items
            : (data.data?.results ?? []);
        final totalCount = data.data?.pagination?.count ??
            data.data?.metrics?.totalCount ??
            results.length;
        final totalPages = data.data?.pagination?.totalPages ??
            (totalCount > 0 ? (totalCount / event.limit).ceil() : 1);
        final hasReachedMax =
            _currentPage >= totalPages || results.length < event.limit;

        emit(RefundsSuccessState(
          data,
          allResults: results,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _loadMoreRefunds(
    LoadMoreRefundsEvent event,
    Emitter<RefundsState> emit,
  ) async {
    if (state is! RefundsSuccessState) return;

    final currentSuccess = state as RefundsSuccessState;
    if (currentSuccess.hasReachedMax || currentSuccess.isLoadingMore) return;

    emit(currentSuccess.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;

    final result = await _refundsUseCase.call(
      RefundsParams(
        page: nextPage,
        limit: _limit,
        status: _currentStatus,
        search: _currentSearch,
        dateFrom: _currentDateFrom,
        dateTo: _currentDateTo,
        isDashboard: _currentIsDashboard,
        ordering: _currentOrdering,
        refundType: _currentRefundType,
      ),
    );

    result.fold(
      (failure) {
        emit(currentSuccess.copyWith(isLoadingMore: false));
      },
      (data) {
        _currentPage = nextPage;
        final newItems = data.data?.items.isNotEmpty == true
            ? data.data!.items
            : (data.data?.results ?? []);
        final combined = [...currentSuccess.allResults, ...newItems];
        final totalCount = data.data?.pagination?.count ??
            data.data?.metrics?.totalCount ??
            combined.length;
        final totalPages = data.data?.pagination?.totalPages ??
            (totalCount > 0 ? (totalCount / _limit).ceil() : nextPage);
        final hasReachedMax =
            _currentPage >= totalPages || newItems.isEmpty || newItems.length < _limit;

        emit(currentSuccess.copyWith(
          data: data,
          allResults: combined,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _refreshRefunds(
    RefreshRefundsEvent event,
    Emitter<RefundsState> emit,
  ) async {
    _currentPage = 1;

    final result = await _refundsUseCase.call(
      RefundsParams(
        page: _currentPage,
        limit: _limit,
        status: _currentStatus,
        search: _currentSearch,
        dateFrom: _currentDateFrom,
        dateTo: _currentDateTo,
        isDashboard: _currentIsDashboard,
        ordering: _currentOrdering,
        refundType: _currentRefundType,
      ),
    );

    result.fold(
      (failure) => emit(RefundsFailureState(failure.message)),
      (data) {
        final results = data.data?.items.isNotEmpty == true
            ? data.data!.items
            : (data.data?.results ?? []);
        final totalCount = data.data?.pagination?.count ??
            data.data?.metrics?.totalCount ??
            results.length;
        final totalPages = data.data?.pagination?.totalPages ??
            (totalCount > 0 ? (totalCount / _limit).ceil() : 1);
        final hasReachedMax =
            _currentPage >= totalPages || results.length < _limit;

        emit(RefundsSuccessState(
          data,
          allResults: results,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _filterByStatus(
    FilterRefundsByStatusEvent event,
    Emitter<RefundsState> emit,
  ) async {
    add(GetRefundsEvent(
      page: 1,
      limit: _limit,
      status: event.status,
      search: _currentSearch,
      dateFrom: _currentDateFrom,
      dateTo: _currentDateTo,
      isDashboard: _currentIsDashboard,
      ordering: _currentOrdering,
      refundType: _currentRefundType,
    ));
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE RefundsBloc =====");
    return super.close();
  }
}
