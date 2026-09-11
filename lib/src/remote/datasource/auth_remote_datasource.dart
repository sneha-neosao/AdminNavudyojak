import 'package:dio/dio.dart';

import '../../core/api/api_exception.dart';
import '../../core/api/api_helper.dart';
import '../../core/api/api_url.dart';
import '../../core/constants/error_message.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/logger.dart';
import '../../features/login/domain/usecase/login_usecase.dart';
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
import '../../features/login/domain/usecase/forgot_password_usecase.dart';
import '../../features/profile/domain/usecase/update_fcm_token_usecase.dart';

abstract class RemoteDataSource {
  /// Authentication
  // ignore: non_constant_identifier_names
  Future<LoginResponse> Login(LoginParams params);
  Future<LoginResponse> login(LoginParams params);

  // ignore: non_constant_identifier_names
  Future<LogoutResponse> Logout(String token, String refreshToken);
  Future<LogoutResponse> logout(String token, String refreshToken);

  // ignore: non_constant_identifier_names
  Future<ForgotPasswordResponse> ForgotPassword(ForgotPasswordParams params);
  // ignore: non_constant_identifier_names
  Future<ForgotPasswordResponse> forgot_password(ForgotPasswordParams params);

  /// Customers
  // ignore: non_constant_identifier_names
  Future<CustomersResponse> CustomersList({
    int? page,
    int? limit,
    String? search,
    String? city,
    String? state,
    String? isActive,
  });
  // ignore: non_constant_identifier_names
  Future<CustomersResponse> customers_list({
    int? page,
    int? limit,
    String? search,
    String? city,
    String? state,
    String? isActive,
  });

  // ignore: non_constant_identifier_names
  Future<CustomerDetailsResponse> CustomerDetails(String id);
  // ignore: non_constant_identifier_names
  Future<CustomerDetailsResponse> customer_details(String id);

  /// App Version
  // ignore: non_constant_identifier_names
  Future<AppVersionResponse> AppVersionCheck({String appName = "admin_app"});
  // ignore: non_constant_identifier_names
  Future<AppVersionResponse> app_version_check({String appName = "admin_app"});

  /// Profile
  // ignore: non_constant_identifier_names
  Future<ProfileDetailsResponse> ProfileDetails();
  // ignore: non_constant_identifier_names
  Future<ProfileDetailsResponse> profile_details();

  /// Notifications
  // ignore: non_constant_identifier_names
  Future<NotificationsResponse> NotificationsList({
    int? page,
    int? limit,
    String? status,
  });
  // ignore: non_constant_identifier_names
  Future<NotificationsResponse> notifications_list({
    int? page,
    int? limit,
    String? status,
  });

  // ignore: non_constant_identifier_names
  Future<NotificationsCountResponse> NotificationsCounts();
  // ignore: non_constant_identifier_names
  Future<NotificationsCountResponse> notifications_counts();

  // ignore: non_constant_identifier_names
  Future<MarkAllNotificationsReadResponse> MarkAllNotificationsAsRead();
  // ignore: non_constant_identifier_names
  Future<MarkAllNotificationsReadResponse> mark_all_notifications_as_read();

  // ignore: non_constant_identifier_names
  Future<MarkNotificationReadResponse> MarkNotificationAsRead(String id);
  // ignore: non_constant_identifier_names
  Future<MarkNotificationReadResponse> mark_notification_as_read(String id);

  /// Analytics
  // ignore: non_constant_identifier_names
  Future<BusinessPerformanceResponse> BusinessPerformance();
  // ignore: non_constant_identifier_names
  Future<BusinessPerformanceResponse> business_performance();

  /// Dashboard
  // ignore: non_constant_identifier_names
  Future<AdminDashboardResponse> AdminDashboard({String? period});
  // ignore: non_constant_identifier_names
  Future<AdminDashboardResponse> admin_dashboard({String? period});

  /// FCM Token Update
  // ignore: non_constant_identifier_names
  Future<UpdateFcmTokenResponse> UpdateFcmToken(UpdateFcmTokenParams params);
  // ignore: non_constant_identifier_names
  Future<UpdateFcmTokenResponse> update_fcm_token(UpdateFcmTokenParams params);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiHelper _helper;

  RemoteDataSourceImpl(this._helper);

  @override
  // ignore: non_constant_identifier_names
  Future<LoginResponse> Login(LoginParams params) async {
    return login(params);
  }

  @override
  Future<LoginResponse> login(LoginParams params) async {
    try {
      var data = {
        "email": params.email,
        "password": params.password,
        "app_type": params.appType,
      };

      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.login,
        data: data,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'X-CSRFTOKEN': '7aKIiDw0PyKYMvkSD98l85bREOUXMiZKY3SA5bE32jbMslB6cazEsoap2mNFTFAk',
          },
        ),
      );

      final respData = LoginResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<LogoutResponse> Logout(String token, String refreshToken) async {
    return logout(token, refreshToken);
  }

  @override
  Future<LogoutResponse> logout(String token, String refreshToken) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.logout,
        data: {"refresh": refreshToken},
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
            'X-CSRFTOKEN': '7aKIiDw0PyKYMvkSD98l85bREOUXMiZKY3SA5bE32jbMslB6cazEsoap2mNFTFAk',
          },
        ),
      );

      final respData = LogoutResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<CustomersResponse> CustomersList({
    int? page,
    int? limit,
    String? search,
    String? city,
    String? state,
    String? isActive,
  }) async {
    return customers_list(
      page: page,
      limit: limit,
      search: search,
      city: city,
      state: state,
      isActive: isActive,
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future<CustomersResponse> customers_list({
    int? page,
    int? limit,
    String? search,
    String? city,
    String? state,
    String? isActive,
  }) async {
    try {
      String url = ApiUrl.customers;
      final queryParams = <String, String>{};
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (city != null && city.trim().isNotEmpty) {
        queryParams['city'] = city.trim();
      }
      if (state != null && state.trim().isNotEmpty) {
        queryParams['state'] = state.trim();
      }
      if (isActive != null && isActive.trim().isNotEmpty) {
        queryParams['is_active'] = isActive.trim();
      }

      if (queryParams.isNotEmpty) {
        final query = Uri(queryParameters: queryParams).query;
        url = '$url?$query';
      }

      final response = await _helper.execute(
        method: Method.get,
        url: url,
        options: Options(headers: {'accept': 'application/json'}),
      );

      final respData = CustomersResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<CustomerDetailsResponse> CustomerDetails(String id) async {
    return customer_details(id);
  }

  @override
  // ignore: non_constant_identifier_names
  Future<CustomerDetailsResponse> customer_details(String id) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.customerDetails(id),
        options: Options(headers: {'accept': 'application/json'}),
      );

      final respData = CustomerDetailsResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<AppVersionResponse> AppVersionCheck({
    String appName = "admin_app",
  }) async {
    return app_version_check(appName: appName);
  }

  @override
  // ignore: non_constant_identifier_names
  Future<AppVersionResponse> app_version_check({
    String appName = "admin_app",
  }) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.appVersionCheckUrl(appName: appName),
        options: Options(headers: {'accept': 'application/json'}),
      );

      final respData = AppVersionResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<ProfileDetailsResponse> ProfileDetails() async {
    return profile_details();
  }

  @override
  // ignore: non_constant_identifier_names
  Future<ProfileDetailsResponse> profile_details() async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.authProfile,
        options: Options(headers: {'accept': 'application/json'}),
      );

      final respData = ProfileDetailsResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<NotificationsResponse> NotificationsList({
    int? page,
    int? limit,
    String? status,
  }) async {
    return notifications_list(page: page, limit: limit, status: status);
  }

  @override
  // ignore: non_constant_identifier_names
  Future<NotificationsResponse> notifications_list({
    int? page,
    int? limit,
    String? status,
  }) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.notificationsUrl(page: page, limit: limit, status: status),
        options: Options(headers: {'accept': 'application/json'}),
      );

      final respData = NotificationsResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<ForgotPasswordResponse> ForgotPassword(
    ForgotPasswordParams params,
  ) async {
    return forgot_password(params);
  }

  @override
  // ignore: non_constant_identifier_names
  Future<ForgotPasswordResponse> forgot_password(
    ForgotPasswordParams params,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.forgotPassword,
        data: params.toJson(),
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final respData = ForgotPasswordResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<NotificationsCountResponse> NotificationsCounts() async {
    return notifications_counts();
  }

  @override
  // ignore: non_constant_identifier_names
  Future<NotificationsCountResponse> notifications_counts() async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.notificationsCounts,
        options: Options(headers: {'accept': 'application/json'}),
      );

      final respData = NotificationsCountResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<MarkAllNotificationsReadResponse> MarkAllNotificationsAsRead() async {
    return mark_all_notifications_as_read();
  }

  @override
  // ignore: non_constant_identifier_names
  Future<MarkAllNotificationsReadResponse>
  mark_all_notifications_as_read() async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.markAllNotificationsAsRead,
        options: Options(headers: {'accept': 'application/json'}),
      );

      final respData = MarkAllNotificationsReadResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<BusinessPerformanceResponse> BusinessPerformance() async {
    return business_performance();
  }

  @override
  // ignore: non_constant_identifier_names
  Future<BusinessPerformanceResponse> business_performance() async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.businessPerformance,
        options: Options(headers: {'accept': 'application/json'}),
      );

      final respData = BusinessPerformanceResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<UpdateFcmTokenResponse> UpdateFcmToken(
    UpdateFcmTokenParams params,
  ) async {
    return update_fcm_token(params);
  }

  @override
  // ignore: non_constant_identifier_names
  Future<UpdateFcmTokenResponse> update_fcm_token(
    UpdateFcmTokenParams params,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.put,
        url: ApiUrl.updateFcmToken,
        data: {'fcm_token': params.fcmToken},
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      final respData = UpdateFcmTokenResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<MarkNotificationReadResponse> MarkNotificationAsRead(String id) async {
    return mark_notification_as_read(id);
  }

  @override
  // ignore: non_constant_identifier_names
  Future<MarkNotificationReadResponse> mark_notification_as_read(
    String id,
  ) async {
    try {
      final response = await _helper.execute(
        method: Method.post,
        url: ApiUrl.markNotificationAsRead(id),
        options: Options(headers: {'accept': 'application/json'}),
      );

      final respData = MarkNotificationReadResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<AdminDashboardResponse> AdminDashboard({String? period}) async {
    return admin_dashboard(period: period);
  }

  @override
  // ignore: non_constant_identifier_names
  Future<AdminDashboardResponse> admin_dashboard({String? period}) async {
    try {
      final response = await _helper.execute(
        method: Method.get,
        url: ApiUrl.adminDashboardUrl(period: period),
        options: Options(headers: {'accept': 'application/json'}),
      );

      final respData = AdminDashboardResponse.fromJson(response);
      return respData;
    } on EmptyException {
      throw AuthException();
    } catch (e) {
      logger.e(e);
      if (e.toString() == noElement) {
        throw AuthException();
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ServerException();
    }
  }
}
