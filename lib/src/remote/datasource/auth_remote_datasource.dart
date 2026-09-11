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

abstract class RemoteDataSource {
  /// Authentication
  // ignore: non_constant_identifier_names
  Future<LoginResponse> Login(LoginParams params);
  Future<LoginResponse> login(LoginParams params);

  // ignore: non_constant_identifier_names
  Future<LogoutResponse> Logout(String token, String refreshToken);
  Future<LogoutResponse> logout(String token, String refreshToken);

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
        data: {
          "refresh": refreshToken,
        },
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
        options: Options(
          headers: {
            'accept': 'application/json',
          },
        ),
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
        options: Options(
          headers: {
            'accept': 'application/json',
          },
        ),
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
}
