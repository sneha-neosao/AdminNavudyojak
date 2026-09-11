import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/notifications_model/mark_notification_read_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class MarkNotificationReadUseCase
    implements UseCase<MarkNotificationReadResponse, String> {
  final Repository _repository;

  const MarkNotificationReadUseCase(this._repository);

  @override
  Future<Either<Failure, MarkNotificationReadResponse>> call(
    String params,
  ) async {
    return _repository.mark_notification_as_read(params);
  }
}
