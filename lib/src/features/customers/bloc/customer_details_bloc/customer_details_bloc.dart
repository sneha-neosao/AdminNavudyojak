import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecase/customer_details_usecase.dart';
import '../../../../remote/models/customers_model/customer_details_response.dart';

part 'customer_details_event.dart';
part 'customer_details_state.dart';

class CustomerDetailsBloc
    extends Bloc<CustomerDetailsEvent, CustomerDetailsState> {
  final CustomerDetailsUseCase _customerDetailsUseCase;

  CustomerDetailsBloc(this._customerDetailsUseCase)
      : super(CustomerDetailsInitialState()) {
    on<GetCustomerDetailsEvent>(_getCustomerDetails);
    on<RefreshCustomerDetailsEvent>(_refreshCustomerDetails);
  }

  Future<void> _getCustomerDetails(
    GetCustomerDetailsEvent event,
    Emitter<CustomerDetailsState> emit,
  ) async {
    emit(CustomerDetailsLoadingState());

    final result = await _customerDetailsUseCase.call(event.id);

    result.fold(
      (failure) => emit(CustomerDetailsFailureState(failure.message)),
      (data) => emit(CustomerDetailsSuccessState(data)),
    );
  }

  Future<void> _refreshCustomerDetails(
    RefreshCustomerDetailsEvent event,
    Emitter<CustomerDetailsState> emit,
  ) async {
    final result = await _customerDetailsUseCase.call(event.id);

    result.fold(
      (failure) => emit(CustomerDetailsFailureState(failure.message)),
      (data) => emit(CustomerDetailsSuccessState(data)),
    );
  }

  @override
  Future<void> close() {
    logger.i("===== CLOSE CustomerDetailsBloc =====");
    return super.close();
  }
}
