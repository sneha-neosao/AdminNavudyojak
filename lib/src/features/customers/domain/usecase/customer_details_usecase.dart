import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/customers_model/customer_details_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class CustomerDetailsUseCase implements UseCase<CustomerDetailsResponse, String> {
  final Repository _repository;

  const CustomerDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, CustomerDetailsResponse>> call(String params) {
    return _repository.customer_details(params);
  }
}
