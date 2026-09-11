import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/app_version_model/app_version_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class AppVersionParams extends Equatable {
  final String appName;

  const AppVersionParams({this.appName = 'admin_app'});

  @override
  List<Object?> get props => [appName];
}

class AppVersionUseCase implements UseCase<AppVersionResponse, AppVersionParams> {
  final Repository _repository;

  const AppVersionUseCase(this._repository);

  @override
  Future<Either<Failure, AppVersionResponse>> call(AppVersionParams params) {
    return _repository.app_version_check(params);
  }
}
