import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/profile_model/profile_details_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class ProfileDetailsUseCase implements UseCase<ProfileDetailsResponse, NoParams> {
  final Repository _repository;

  const ProfileDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileDetailsResponse>> call(NoParams params) {
    return _repository.profile_details(params);
  }
}
