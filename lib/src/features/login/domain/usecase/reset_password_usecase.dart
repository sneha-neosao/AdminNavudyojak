import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/auth_model/reset_password_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

/// UseCase to reset user password with validation adhering to Rule 3.
class ResetPasswordUseCase
    implements UseCase<ResetPasswordResponse, ResetPasswordParams> {
  final Repository _repository;

  const ResetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, ResetPasswordResponse>> call(
    ResetPasswordParams params,
  ) async {
    final token = params.token.trim();
    final password = params.password.trim();
    final passwordConfirm = params.passwordConfirm.trim();

    if (token.isEmpty) {
      return Left(EmptyFailure('Reset token is required'));
    }

    if (password.isEmpty) {
      return Left(EmptyFailure('Please enter password'));
    }

    if (passwordConfirm.isEmpty) {
      return Left(EmptyFailure('Please enter confirm password'));
    }

    if (password != passwordConfirm) {
      return Left(PasswordNotMatchFailure('Both password values must be the same'));
    }

    return _repository.reset_password(
      ResetPasswordParams(
        token: token,
        password: password,
        passwordConfirm: passwordConfirm,
      ),
    );
  }
}

class ResetPasswordParams extends Equatable {
  final String token;
  final String password;
  final String passwordConfirm;

  const ResetPasswordParams({
    required this.token,
    required this.password,
    required this.passwordConfirm,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'password': password,
        'password_confirm': passwordConfirm,
      };

  @override
  List<Object?> get props => [token, password, passwordConfirm];
}
