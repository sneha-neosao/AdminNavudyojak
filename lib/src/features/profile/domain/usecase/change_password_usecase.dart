import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/auth_model/change_password_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

class ChangePasswordParams extends Equatable {
  final String userId;
  final String password;
  final String passwordConfirm;

  const ChangePasswordParams({
    required this.userId,
    required this.password,
    required this.passwordConfirm,
  });

  @override
  List<Object?> get props => [userId, password, passwordConfirm];
}

class ChangePasswordUseCase
    implements UseCase<ChangePasswordResponse, ChangePasswordParams> {
  final Repository _repository;

  const ChangePasswordUseCase(this._repository);

  @override
  Future<Either<Failure, ChangePasswordResponse>> call(
    ChangePasswordParams params,
  ) async {
    if (params.password.trim().isEmpty) {
      return Left(EmptyFailure('Please enter password'));
    }

    if (params.passwordConfirm.trim().isEmpty) {
      return Left(EmptyFailure('Please re-enter password'));
    }

    if (params.password.trim() != params.passwordConfirm.trim()) {
      return Left(PasswordNotMatchFailure('Passwords do not match'));
    }

    return _repository.change_password(params);
  }
}
