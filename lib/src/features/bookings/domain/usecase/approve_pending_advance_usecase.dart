import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/bookings_model/approve_pending_advance_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class ApprovePendingAdvanceUseCase
    implements UseCase<ApprovePendingAdvanceResponse, String> {
  final Repository _repository;

  const ApprovePendingAdvanceUseCase(this._repository);

  @override
  Future<Either<Failure, ApprovePendingAdvanceResponse>> call(
    String params,
  ) {
    return _repository.approve_pending_advance(params);
  }
}
