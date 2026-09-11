import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/analytics_model/business_performance_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class BusinessPerformanceUseCase
    implements UseCase<BusinessPerformanceResponse, NoParams> {
  final Repository _repository;

  const BusinessPerformanceUseCase(this._repository);

  @override
  Future<Either<Failure, BusinessPerformanceResponse>> call(
    NoParams params,
  ) async {
    return _repository.business_performance(params);
  }
}
