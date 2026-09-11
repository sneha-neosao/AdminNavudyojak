import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:admin_navudyojak/src/core/errors/failures.dart';
import 'package:admin_navudyojak/src/core/extensions/string_validator_extension.dart';
import 'package:admin_navudyojak/src/core/usecases/usecase.dart';
import 'package:admin_navudyojak/src/remote/models/auth_model/Login_response.dart';
import 'package:admin_navudyojak/src/remote/repositories/repository_impl.dart';

class AuthLoginUseCase implements UseCase<LoginResponse, LoginParams> {
  final Repository _repository;

  const AuthLoginUseCase(this._repository);

  @override
  Future<Either<Failure, LoginResponse>> call(LoginParams params) async {
    final email = params.email.trim();
    final password = params.password.trim();

    // 1. Empty email validation
    if (email.isEmpty) {
      return Left(EmptyFailure('please_enter_email'.tr()));
    }

    // 2. Valid email format validation
    if (!email.isEmailValid) {
      return Left(InvalidEmailFailure('please_enter_valid_email'.tr()));
    }

    // 3. Empty password validation
    if (password.isEmpty) {
      return Left(EmptyFailure('please_enter_password'.tr()));
    }

    // 4. Password minimum length validation
    if (password.length < 6) {
      return Left(InvalidPasswordFailure('please_enter_valid_password'.tr()));
    }

    return _repository.login(
      LoginParams(
        email: email,
        password: password,
        appType: params.appType,
      ),
    );
  }
}

typedef LoginUseCase = AuthLoginUseCase;

class LoginParams extends Equatable {
  final String email;
  final String password;
  final String appType;

  const LoginParams({
    required this.email,
    required this.password,
    this.appType = 'admin_app',
  });

  @override
  List<Object?> get props => [email, password, appType];
}
