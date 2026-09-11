import 'package:fpdart/fpdart.dart';
import 'package:admin_navudyojak/src/core/errors/failures.dart';
import 'package:admin_navudyojak/src/core/usecases/usecase.dart';
import 'package:admin_navudyojak/src/remote/models/common_response.dart';
import 'package:admin_navudyojak/src/remote/repositories/repository_impl.dart';

class LogoutUseCase implements UseCase<CommonResponse, NoParams> {
  final Repository _repository;

  const LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, CommonResponse>> call(NoParams params) {
    return _repository.logout(params);
  }
}
