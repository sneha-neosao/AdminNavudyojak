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
import '../models/auth_model/logout_response.dart';
import '../models/customers_model/customers_response.dart';
import '../models/customers_model/customer_details_response.dart';
import '../models/app_version_model/app_version_response.dart';
import '../models/profile_model/profile_details_response.dart';
import '../models/notifications_model/notifications_response.dart';
import '../../features/customers/domain/usecase/customers_usecase.dart';
import '../../features/app_version/domain/usecase/app_version_usecase.dart';
import '../../features/notifications/domain/usecase/notifications_usecase.dart';

/// Abstract Repository interface defining all data operations for the app
abstract class Repository {
  /// Authentication
  Future<Either<Failure, LoginResponse>> login(LoginParams params);
  Future<Either<Failure, LogoutResponse>> logout(NoParams params);

  /// Customers
  // ignore: non_constant_identifier_names
  Future<Either<Failure, CustomersResponse>> customers_list(CustomersParams params);
  // ignore: non_constant_identifier_names
  Future<Either<Failure, CustomerDetailsResponse>> customer_details(String id);

  /// App Version
  // ignore: non_constant_identifier_names
  Future<Either<Failure, AppVersionResponse>> app_version_check(AppVersionParams params);

  /// Profile
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ProfileDetailsResponse>> profile_details(NoParams params);

  /// Notifications
  // ignore: non_constant_identifier_names
  Future<Either<Failure, NotificationsResponse>> notifications_list(NotificationsParams params);
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

          if (respData.success == false) {
            return Left(CredentialFailure(
              respData.message?.isNotEmpty == true
                  ? respData.message!
                  : "Invalid credentials",
            ));
          }

          // Save login status & full session object
          await SessionManager.saveLoginStatus(true);
          await SessionManager.saveUserSession(respData);

          // Save tokens to their dedicated keys so ApiInterceptor can read them
          if (respData.data?.accessToken != null && respData.data!.accessToken!.isNotEmpty) {
            await SessionManager.saveSessionId(respData.data?.accessToken);
          }
          if (respData.data?.refreshToken != null && respData.data!.refreshToken!.isNotEmpty) {
            await SessionManager.saveRefreshToken(respData.data?.refreshToken);
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
  Future<Either<Failure, LogoutResponse>> logout(NoParams params) {
    return _networkInfo.check<LogoutResponse>(
      connected: () async {
        try {
          String token = await SessionManager.getAuthToken() ?? "";
          String refreshToken = await SessionManager.getRefreshToken() ?? "";

          final respData = await _remoteDataSource.logout(token, refreshToken);

          if (respData.success == false) {
            return Left(CredentialFailure(
              respData.message?.isNotEmpty == true
                  ? respData.message!
                  : "Logout failed",
            ));
          }

          // Clear session and invalidate login status
          await SessionManager.saveLoginStatus(false);
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

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, CustomersResponse>> customers_list(CustomersParams params) {
    return _networkInfo.check<CustomersResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.customers_list(
            page: params.page,
            limit: params.limit,
            search: params.search,
            city: params.city,
            state: params.state,
            isActive: params.isActive,
          );

          if (respData.success == false) {
            return Left(ServerFailure(
              respData.message?.isNotEmpty == true
                  ? respData.message!
                  : "Failed to retrieve customers",
            ));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
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
  // ignore: non_constant_identifier_names
  Future<Either<Failure, CustomerDetailsResponse>> customer_details(String id) {
    return _networkInfo.check<CustomerDetailsResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.customer_details(id);

          if (respData.success == false) {
            return Left(ServerFailure(
              respData.message?.isNotEmpty == true
                  ? respData.message!
                  : "Failed to retrieve customer details",
            ));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
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
  // ignore: non_constant_identifier_names
  Future<Either<Failure, AppVersionResponse>> app_version_check(AppVersionParams params) {
    return _networkInfo.check<AppVersionResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.app_version_check(appName: params.appName);

          if (respData.success == false) {
            return Left(ServerFailure(
              respData.message?.isNotEmpty == true
                  ? respData.message!
                  : "Failed to check app version",
            ));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
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
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ProfileDetailsResponse>> profile_details(NoParams params) {
    return _networkInfo.check<ProfileDetailsResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.profile_details();

          if (respData.success == false) {
            return Left(ServerFailure(
              respData.message?.isNotEmpty == true
                  ? respData.message!
                  : "Failed to fetch profile details",
            ));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
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
  // ignore: non_constant_identifier_names
  Future<Either<Failure, NotificationsResponse>> notifications_list(NotificationsParams params) {
    return _networkInfo.check<NotificationsResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.notifications_list(
            page: params.page,
            limit: params.limit,
          );

          if (respData.success == false) {
            return Left(ServerFailure(
              respData.message?.isNotEmpty == true
                  ? respData.message!
                  : "Failed to fetch notifications",
            ));
          }

          return Right(respData);
        } on ServerException {
          return Left(ServerFailure(mapFailureToMessage(ServerFailure(""))));
        } catch (e) {
          if (e is ApiException) {
            return Left(ApiFailure(e.message));
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
