import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecase/customers_usecase.dart';
import '../../../../remote/models/customers_model/customers_response.dart';

part 'customers_event.dart';
part 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final CustomersUseCase _customersUseCase;

  int _currentPage = 1;
  static const int _limit = 10;
  String? _currentSearch;
  String? _currentCity;
  String? _currentState;
  String? _currentIsActive;

  CustomersBloc(this._customersUseCase) : super(CustomersInitialState()) {
    on<GetCustomersEvent>(_getCustomers);
    on<LoadMoreCustomersEvent>(_loadMoreCustomers);
    on<RefreshCustomersEvent>(_refreshCustomers);
  }

  Future<void> _getCustomers(
    GetCustomersEvent event,
    Emitter<CustomersState> emit,
  ) async {
    _currentPage = event.page;
    _currentSearch = event.search;
    _currentCity = event.city;
    _currentState = event.state;
    _currentIsActive = event.isActive;

    emit(CustomersLoadingState());

    final result = await _customersUseCase.call(
      CustomersParams(
        page: _currentPage,
        limit: event.limit,
        search: _currentSearch,
        city: _currentCity,
        state: _currentState,
        isActive: _currentIsActive,
      ),
    );

    result.fold(
      (failure) => emit(CustomersFailureState(failure.message)),
      (data) {
        final results = data.data?.results ?? [];
        final totalPages = data.data?.pagination?.totalPages ?? 1;
        final hasReachedMax = _currentPage >= totalPages || results.length < event.limit;

        emit(CustomersSuccessState(
          data,
          allResults: results,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _loadMoreCustomers(
    LoadMoreCustomersEvent event,
    Emitter<CustomersState> emit,
  ) async {
    if (state is! CustomersSuccessState) return;

    final currentSuccess = state as CustomersSuccessState;
    if (currentSuccess.hasReachedMax || currentSuccess.isLoadingMore) return;

    emit(currentSuccess.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;

    final result = await _customersUseCase.call(
      CustomersParams(
        page: nextPage,
        limit: _limit,
        search: _currentSearch,
        city: _currentCity,
        state: _currentState,
        isActive: _currentIsActive,
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

        emit(CustomersSuccessState(
          data,
          allResults: combined,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _refreshCustomers(
    RefreshCustomersEvent event,
    Emitter<CustomersState> emit,
  ) async {
    _currentPage = 1;

    final result = await _customersUseCase.call(
      CustomersParams(
        page: 1,
        limit: _limit,
        search: _currentSearch,
        city: _currentCity,
        state: _currentState,
        isActive: _currentIsActive,
      ),
    );

    result.fold(
      (failure) => emit(CustomersFailureState(failure.message)),
      (data) {
        final results = data.data?.results ?? [];
        final totalPages = data.data?.pagination?.totalPages ?? 1;
        final hasReachedMax = _currentPage >= totalPages || results.length < _limit;

        emit(CustomersSuccessState(
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
    logger.i("===== CLOSE CustomersBloc =====");
    return super.close();
  }
}
