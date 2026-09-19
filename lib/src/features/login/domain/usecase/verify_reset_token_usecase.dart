import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../remote/models/auth_model/verify_reset_token_response.dart';
import '../../../../remote/repositories/repository_impl.dart';

/// UseCase to verify the password reset token adhering to Rule 3.
class VerifyResetTokenUseCase
    implements UseCase<VerifyResetTokenResponse, VerifyResetTokenParams> {
  final Repository _repository;

  const VerifyResetTokenUseCase(this._repository);

  @override
  Future<Either<Failure, VerifyResetTokenResponse>> call(
    VerifyResetTokenParams params,
  ) async {
    final token = params.token.trim();

    if (token.isEmpty) {
      return Left(EmptyFailure('Reset token is required'));
    }

    return _repository.verify_reset_token(
      VerifyResetTokenParams(token: token),
    );
  }
}

class VerifyResetTokenParams extends Equatable {
  final String token;

  const VerifyResetTokenParams({
    required this.token,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
      };

  @override
  List<Object?> get props => [token];
}
