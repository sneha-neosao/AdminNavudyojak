import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:admin_navudyojak/src/core/errors/failures.dart';
import 'package:admin_navudyojak/src/core/usecases/usecase.dart';
import 'package:admin_navudyojak/src/remote/models/auth_model/Login_response.dart';
import 'package:admin_navudyojak/src/remote/repositories/repository_impl.dart';

class AuthLoginUseCase implements UseCase<LoginResponse, LoginParams> {
  final Repository _repository;

  const AuthLoginUseCase(this._repository);

  @override
  Future<Either<Failure, LoginResponse>> call(LoginParams params) {
    return _repository.login(params);
  }
}

typedef LoginUseCase = AuthLoginUseCase;

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
