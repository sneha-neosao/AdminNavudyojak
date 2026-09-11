import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Null-safe model representing the API login response adhering to Rule 12.
class LoginResponse extends Equatable {
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

  factory LoginResponse.fromRawJson(String str) {
    try {
      return LoginResponse.fromJson(json.decode(str) as Map<String, dynamic>);
    } catch (_) {
      return const LoginResponse();
    }
  }

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LoginResponse();
    return LoginResponse(
      status: json['status'] as int? ?? (json['success'] == true ? 200 : null),
      success: json['success'] as bool? ?? (json['status'] == 200 || json['status'] == 201),
      message: json['message']?.toString() ?? '',
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

  @override
  List<Object?> get props => [status, success, message, data];
}

class LoginTokenData extends Equatable {
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
      refresh: json['refresh']?.toString() ?? '',
      access: json['access']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'refresh': refresh,
        'access': access,
      };

  @override
  List<Object?> get props => [refresh, access];
}
