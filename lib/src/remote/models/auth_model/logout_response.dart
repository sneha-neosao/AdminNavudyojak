import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Null-safe model representing the Logout API response adhering to Rule 12.
class LogoutResponse extends Equatable {
  final int? status;
  final bool? success;
  final String? message;
  final dynamic data;

  const LogoutResponse({
    this.status,
    this.success,
    this.message,
    this.data,
  });

  factory LogoutResponse.fromRawJson(String str) {
    try {
      return LogoutResponse.fromJson(json.decode(str) as Map<String, dynamic>);
    } catch (_) {
      return const LogoutResponse();
    }
  }

  String toRawJson() => json.encode(toJson());

  factory LogoutResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const LogoutResponse();
    return LogoutResponse(
      status: json['status'] as int? ?? (json['success'] == true ? 200 : null),
      success: json['success'] as bool? ?? (json['status'] == 200 || json['status'] == 201),
      message: json['message']?.toString() ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'success': success,
        'message': message,
        'data': data,
      };

  @override
  List<Object?> get props => [status, success, message, data];
}
