import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/customers_model/customers_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class CustomersParams extends Equatable {
  final int page;
  final int limit;
  final String? search;
  final String? city;
  final String? state;
  final String? isActive;

  const CustomersParams({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.city,
    this.state,
    this.isActive,
  });

  @override
  List<Object?> get props => [page, limit, search, city, state, isActive];
}

class CustomersUseCase implements UseCase<CustomersResponse, CustomersParams> {
  final Repository _repository;

  const CustomersUseCase(this._repository);

  @override
  Future<Either<Failure, CustomersResponse>> call(CustomersParams params) {
    return _repository.customers_list(params);
  }
}
