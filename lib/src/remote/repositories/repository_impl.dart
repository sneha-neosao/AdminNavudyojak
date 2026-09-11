import 'package:fpdart/fpdart.dart';
import '../../core/api/api_exception.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_checker.dart';
import '../../core/session/session_manager.dart';
import '../../core/usecases/usecase.dart';
import '../../core/utils/failure_converter.dart';
import '../../features/login/domain/usecase/login_usecase.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/auth_model/Login_response.dart';
import '../models/common_response.dart';

/// Abstract Repository interface defining all data operations for the app
abstract class Repository {
  /// Authentication
  Future<Either<Failure, LoginResponse>> login(LoginParams params);
  Future<Either<Failure, CommonResponse>> logout(NoParams params);
}

class AuthRepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const AuthRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, LoginResponse>> login(LoginParams params) {
    return _networkInfo.check<LoginResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.login(params);

          if (respData.status != null && respData.status != 200 && respData.success == false) {
            return Left(CredentialFailure(respData.message ?? "Invalid credentials"));
          }

          // Save login status & full session object
          await SessionManager.saveLoginStatus(true);
          await SessionManager.saveUserSession(respData);

          // Save tokens to their dedicated keys so ApiInterceptor can read them
          if (respData.data?.access != null) {
            await SessionManager.saveSessionId(respData.data?.access);
          }
          if (respData.data?.refresh != null) {
            await SessionManager.saveRefreshToken(respData.data?.refresh);
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  Future<Either<Failure, CommonResponse>> logout(NoParams params) {
    return _networkInfo.check<CommonResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          String refreshToken = await SessionManager.getRefreshToken() ?? "";

          final respData = await _remoteDataSource.logout(token, refreshToken);

          if (respData.status != 200) {
            return Left(CredentialFailure(respData.message));
          }

          await SessionManager.clear();

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message)); // rethrow as-is
          }
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        }
      },
      notConnected: () async {
        try {
          return Left(InternetFailure(mapFailureToMessage(InternetFailure(""))));
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }
}
