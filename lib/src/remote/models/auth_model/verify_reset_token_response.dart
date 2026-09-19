import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Null-safe model representing the Verify Reset Token API response adhering to Rule 12.
class VerifyResetTokenResponse extends Equatable {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? data;
  final dynamic errors;

  const VerifyResetTokenResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory VerifyResetTokenResponse.fromRawJson(String str) {
    try {
      return VerifyResetTokenResponse.fromJson(
        json.decode(str) as Map<String, dynamic>?,
      );
    } catch (_) {
      return const VerifyResetTokenResponse();
    }
  }

  String toRawJson() => json.encode(toJson());

  factory VerifyResetTokenResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const VerifyResetTokenResponse();
    return VerifyResetTokenResponse(
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
