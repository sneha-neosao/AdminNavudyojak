import 'dart:convert';

/// Null-safe model representing the API login response.
class LoginResponse {
  final int? status;
  final bool? success;
  final String? message;
  final LoginTokenData? data;

  const LoginResponse({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LoginResponse();
    return LoginResponse(
      status: json['status'] as int?,
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? LoginTokenData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class LoginTokenData {
  final String? refresh;
  final String? access;

  String? get accessToken => access;
  String? get refreshToken => refresh;

  const LoginTokenData({
    this.refresh,
    this.access,
  });

  factory LoginTokenData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LoginTokenData();
    return LoginTokenData(
      refresh: json['refresh'] as String?,
      access: json['access'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'refresh': refresh,
        'access': access,
      };
}
