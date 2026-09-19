import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Null-safe model representing the Reset Password API response adhering to Rule 12.
class ResetPasswordResponse extends Equatable {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? data;
  final dynamic errors;

  const ResetPasswordResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory ResetPasswordResponse.fromRawJson(String str) {
    try {
      return ResetPasswordResponse.fromJson(
        json.decode(str) as Map<String, dynamic>?,
      );
    } catch (_) {
      return const ResetPasswordResponse();
    }
  }

  String toRawJson() => json.encode(toJson());

  factory ResetPasswordResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ResetPasswordResponse();
    return ResetPasswordResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : <String, dynamic>{},
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data,
        'errors': errors,
      };

  @override
  List<Object?> get props => [success, message, data, errors];
}
