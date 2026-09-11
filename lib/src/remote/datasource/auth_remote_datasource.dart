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

abstract class RemoteDataSource {
  /// Authentication
  Future<LoginResponse> Login(LoginParams params);
  Future<LoginResponse> login(LoginParams params);

  Future<LogoutResponse> Logout(String token, String refreshToken);
  Future<LogoutResponse> logout(String token, String refreshToken);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiHelper _helper;

  RemoteDataSourceImpl(this._helper);

  @override
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
}
