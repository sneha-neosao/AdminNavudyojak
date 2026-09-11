import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/notifications_model/notifications_count_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class NotificationsCountUseCase
    implements UseCase<NotificationsCountResponse, NoParams> {
  final Repository _repository;

  const NotificationsCountUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationsCountResponse>> call(
    NoParams params,
  ) async {
    return _repository.notifications_counts(params);
  }
}
