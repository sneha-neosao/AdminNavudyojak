import 'package:fpdart/fpdart.dart';
import 'package:admin_navudyojak/src/core/errors/failures.dart';
import 'package:admin_navudyojak/src/core/usecases/usecase.dart';
import 'package:admin_navudyojak/src/remote/models/auth_model/logout_response.dart';
import 'package:admin_navudyojak/src/remote/repositories/repository_impl.dart';

class LogoutUseCase implements UseCase<LogoutResponse, NoParams> {
  final Repository _repository;

  const LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, LogoutResponse>> call(NoParams params) {
    return _repository.logout(params);
  }
}
