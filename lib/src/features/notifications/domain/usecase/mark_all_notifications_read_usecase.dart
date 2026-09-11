import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/notifications_model/mark_all_read_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class MarkAllNotificationsReadUseCase
    implements UseCase<MarkAllNotificationsReadResponse, NoParams> {
  final Repository _repository;

  const MarkAllNotificationsReadUseCase(this._repository);

  @override
  Future<Either<Failure, MarkAllNotificationsReadResponse>> call(
    NoParams params,
  ) async {
    return _repository.mark_all_notifications_as_read(params);
  }
}
