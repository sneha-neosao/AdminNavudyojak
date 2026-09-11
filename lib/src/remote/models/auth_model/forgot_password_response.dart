import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Null-safe model representing the Forgot Password API response adhering to Rule 12.
class ForgotPasswordResponse extends Equatable {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? data;
  final dynamic errors;

  const ForgotPasswordResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory ForgotPasswordResponse.fromRawJson(String str) {
    try {
      return ForgotPasswordResponse.fromJson(
        json.decode(str) as Map<String, dynamic>?,
      );
    } catch (_) {
      return const ForgotPasswordResponse();
    }
  }

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ForgotPasswordResponse();
    return ForgotPasswordResponse(
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
