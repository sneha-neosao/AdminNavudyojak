import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/notifications_model/notifications_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class NotificationsParams extends Equatable {
  final int page;
  final int limit;

  const NotificationsParams({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

class NotificationsUseCase implements UseCase<NotificationsResponse, NotificationsParams> {
  final Repository _repository;

  const NotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationsResponse>> call(NotificationsParams params) {
    return _repository.notifications_list(params);
  }
}
