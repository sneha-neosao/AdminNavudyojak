import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/profile_model/update_fcm_token_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class UpdateFcmTokenParams extends Equatable {
  final String fcmToken;

  const UpdateFcmTokenParams({required this.fcmToken});

  @override
  List<Object?> get props => [fcmToken];
}

class UpdateFcmTokenUseCase
    implements UseCase<UpdateFcmTokenResponse, UpdateFcmTokenParams> {
  final Repository _repository;

  const UpdateFcmTokenUseCase(this._repository);

  @override
  Future<Either<Failure, UpdateFcmTokenResponse>> call(
      UpdateFcmTokenParams params) {
    return _repository.update_fcm_token(params);
  }
}
