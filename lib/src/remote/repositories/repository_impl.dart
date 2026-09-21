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
import '../models/profile_model/update_fcm_token_response.dart';
import '../models/notifications_model/notifications_response.dart';
import '../models/notifications_model/notifications_count_response.dart';
import '../models/notifications_model/mark_all_read_response.dart';
import '../models/notifications_model/mark_notification_read_response.dart';
import '../models/analytics_model/business_performance_response.dart';
import '../models/dashboard_model/admin_dashboard_response.dart';
import '../models/auth_model/forgot_password_response.dart';
import '../models/auth_model/verify_reset_token_response.dart';
import '../models/auth_model/reset_password_response.dart';
import '../../features/customers/domain/usecase/customers_usecase.dart';
import '../../features/app_version/domain/usecase/app_version_usecase.dart';
import '../../features/notifications/domain/usecase/notifications_usecase.dart';
import '../../features/login/domain/usecase/forgot_password_usecase.dart';
import '../../features/login/domain/usecase/verify_reset_token_usecase.dart';
import '../../features/login/domain/usecase/reset_password_usecase.dart';
import '../../features/profile/domain/usecase/update_fcm_token_usecase.dart';
import '../../features/home/domain/usecase/admin_dashboard_usecase.dart';
import '../models/auth_model/change_password_response.dart';
import '../../features/profile/domain/usecase/change_password_usecase.dart';
import '../models/request_model/refunds_response.dart';
import '../../features/request/domain/usecase/refunds_usecase.dart';
import '../models/bookings_model/pending_advance_bookings_response.dart';
import '../../features/bookings/domain/usecase/pending_advance_bookings_usecase.dart';
import '../models/bookings_model/pending_advance_booking_details_response.dart';
import '../models/bookings_model/approve_pending_advance_response.dart';

/// Abstract Repository interface defining all data operations for the app
abstract class Repository {
  /// Authentication
  Future<Either<Failure, LoginResponse>> login(LoginParams params);
  Future<Either<Failure, LogoutResponse>> logout(NoParams params);
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ForgotPasswordResponse>> forgot_password(
    ForgotPasswordParams params,
  );
  // ignore: non_constant_identifier_names
  Future<Either<Failure, VerifyResetTokenResponse>> verify_reset_token(
    VerifyResetTokenParams params,
  );
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ResetPasswordResponse>> reset_password(
    ResetPasswordParams params,
  );

  /// Customers
  // ignore: non_constant_identifier_names
  Future<Either<Failure, CustomersResponse>> customers_list(
    CustomersParams params,
  );
  // ignore: non_constant_identifier_names
  Future<Either<Failure, CustomerDetailsResponse>> customer_details(String id);

  /// App Version
  // ignore: non_constant_identifier_names
  Future<Either<Failure, AppVersionResponse>> app_version_check(
    AppVersionParams params,
  );

  /// Profile
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ProfileDetailsResponse>> profile_details(
    NoParams params,
  );

  /// Notifications
  // ignore: non_constant_identifier_names
  Future<Either<Failure, NotificationsResponse>> notifications_list(
    NotificationsParams params,
  );
  // ignore: non_constant_identifier_names
  Future<Either<Failure, NotificationsCountResponse>> notifications_counts(
    NoParams params,
  );
  // ignore: non_constant_identifier_names
  Future<Either<Failure, MarkAllNotificationsReadResponse>>
  mark_all_notifications_as_read(NoParams params);
  // ignore: non_constant_identifier_names
  Future<Either<Failure, MarkNotificationReadResponse>>
  mark_notification_as_read(String id);

  /// Analytics
  // ignore: non_constant_identifier_names
  Future<Either<Failure, BusinessPerformanceResponse>> business_performance(
    NoParams params,
  );

  /// Dashboard
  // ignore: non_constant_identifier_names
  Future<Either<Failure, AdminDashboardResponse>> admin_dashboard(
    AdminDashboardParams params,
  );

  /// FCM Token Update
  // ignore: non_constant_identifier_names
  Future<Either<Failure, UpdateFcmTokenResponse>> update_fcm_token(
    UpdateFcmTokenParams params,
  );

  /// Change Password
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ChangePasswordResponse>> change_password(
    ChangePasswordParams params,
  );

  /// Refunds / Requests
  // ignore: non_constant_identifier_names
  Future<Either<Failure, RefundsResponse>> refunds_list(
    RefundsParams params,
  );

  /// Pending Advance Bookings
  // ignore: non_constant_identifier_names
  Future<Either<Failure, PendingAdvanceBookingsResponse>> pending_advance_bookings(
    PendingAdvanceBookingsParams params,
  );

  /// Pending Advance Booking Details
  // ignore: non_constant_identifier_names
  Future<Either<Failure, PendingAdvanceBookingDetailsResponse>> pending_advance_booking_details(
    String id,
  );

  /// Approve Pending Advance
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ApprovePendingAdvanceResponse>> approve_pending_advance(
    String id,
  );
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
            return Left(
              CredentialFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Invalid credentials",
              ),
            );
          }

          // Save login status & full session object
          await SessionManager.saveLoginStatus(true);
          await SessionManager.saveUserSession(respData);

          // Save tokens to their dedicated keys so ApiInterceptor can read them
          if (respData.data?.accessToken != null &&
              respData.data!.accessToken!.isNotEmpty) {
            await SessionManager.saveSessionId(respData.data?.accessToken);
          }
          if (respData.data?.refreshToken != null &&
              respData.data!.refreshToken!.isNotEmpty) {
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
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
            return Left(
              CredentialFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Logout failed",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, CustomersResponse>> customers_list(
    CustomersParams params,
  ) {
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
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to retrieve customers",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
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
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to retrieve customer details",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, AppVersionResponse>> app_version_check(
    AppVersionParams params,
  ) {
    return _networkInfo.check<AppVersionResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.app_version_check(
            appName: params.appName,
          );

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to check app version",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ProfileDetailsResponse>> profile_details(
    NoParams params,
  ) {
    return _networkInfo.check<ProfileDetailsResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.profile_details();

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to fetch profile details",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, NotificationsResponse>> notifications_list(
    NotificationsParams params,
  ) {
    return _networkInfo.check<NotificationsResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.notifications_list(
            page: params.page,
            limit: params.limit,
            status: params.status,
          );

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to fetch notifications",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ForgotPasswordResponse>> forgot_password(
    ForgotPasswordParams params,
  ) async {
    return _networkInfo.check(
      connected: () async {
        try {
          final respData = await _remoteDataSource.forgot_password(params);

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to send reset link",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, VerifyResetTokenResponse>> verify_reset_token(
    VerifyResetTokenParams params,
  ) async {
    return _networkInfo.check(
      connected: () async {
        try {
          final respData = await _remoteDataSource.verify_reset_token(params);

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Invalid or expired reset token",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ResetPasswordResponse>> reset_password(
    ResetPasswordParams params,
  ) async {
    return _networkInfo.check(
      connected: () async {
        try {
          final respData = await _remoteDataSource.reset_password(params);

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to reset password",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, NotificationsCountResponse>> notifications_counts(
    NoParams params,
  ) async {
    return _networkInfo.check(
      connected: () async {
        try {
          final respData = await _remoteDataSource.notifications_counts();

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to fetch notification counts",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, MarkAllNotificationsReadResponse>>
  mark_all_notifications_as_read(NoParams params) async {
    return _networkInfo.check(
      connected: () async {
        try {
          final respData = await _remoteDataSource
              .mark_all_notifications_as_read();

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to mark notifications as read",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, BusinessPerformanceResponse>> business_performance(
    NoParams params,
  ) async {
    return _networkInfo.check(
      connected: () async {
        try {
          final respData = await _remoteDataSource.business_performance();

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to fetch business performance analytics",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, UpdateFcmTokenResponse>> update_fcm_token(
    UpdateFcmTokenParams params,
  ) async {
    return _networkInfo.check(
      connected: () async {
        try {
          final respData = await _remoteDataSource.update_fcm_token(params);

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to update FCM token",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, MarkNotificationReadResponse>>
  mark_notification_as_read(String id) async {
    return _networkInfo.check(
      connected: () async {
        try {
          final respData = await _remoteDataSource.mark_notification_as_read(
            id,
          );

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to mark notification as read",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, AdminDashboardResponse>> admin_dashboard(
    AdminDashboardParams params,
  ) {
    return _networkInfo.check(
      connected: () async {
        try {
          final respData = await _remoteDataSource.admin_dashboard(
            period: params.period,
          );

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to fetch admin dashboard data",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ChangePasswordResponse>> change_password(
    ChangePasswordParams params,
  ) {
    return _networkInfo.check(
      connected: () async {
        try {
          final respData = await _remoteDataSource.change_password(
            userId: params.userId,
            password: params.password,
            passwordConfirm: params.passwordConfirm,
          );

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to change password",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, RefundsResponse>> refunds_list(
    RefundsParams params,
  ) {
    return _networkInfo.check<RefundsResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.refunds_list(
            page: params.page,
            limit: params.limit,
            status: params.status,
            search: params.search,
            dateFrom: params.dateFrom,
            dateTo: params.dateTo,
            isDashboard: params.isDashboard,
            ordering: params.ordering,
            refundType: params.refundType,
          );

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to retrieve refunds",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, PendingAdvanceBookingsResponse>> pending_advance_bookings(
    PendingAdvanceBookingsParams params,
  ) {
    return _networkInfo.check<PendingAdvanceBookingsResponse>(
      connected: () async {
        try {
          final respData = await _remoteDataSource.pending_advance_bookings(
            page: params.page,
            limit: params.limit,
            search: params.search,
          );

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to retrieve pending advance bookings",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, PendingAdvanceBookingDetailsResponse>> pending_advance_booking_details(
    String id,
  ) {
    return _networkInfo.check<PendingAdvanceBookingDetailsResponse>(
      connected: () async {
        try {
          final respData =
              await _remoteDataSource.pending_advance_booking_details(id);

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to retrieve booking details",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<Failure, ApprovePendingAdvanceResponse>> approve_pending_advance(
    String id,
  ) {
    return _networkInfo.check<ApprovePendingAdvanceResponse>(
      connected: () async {
        try {
          final respData =
              await _remoteDataSource.approve_pending_advance(id);

          if (respData.success == false) {
            return Left(
              ServerFailure(
                respData.message?.isNotEmpty == true
                    ? respData.message!
                    : "Failed to approve pending advance",
              ),
            );
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
          return Left(
            InternetFailure(mapFailureToMessage(InternetFailure(""))),
          );
        } on CacheException {
          return Left(CacheFailure(mapFailureToMessage(CacheFailure(""))));
        }
      },
    );
  }
}
