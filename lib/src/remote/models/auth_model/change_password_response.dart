import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Null-safe model representing the Change Password API response adhering to Rule 12.
class ChangePasswordResponse extends Equatable {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? data;
  final dynamic errors;

  const ChangePasswordResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory ChangePasswordResponse.fromRawJson(String str) {
    try {
      return ChangePasswordResponse.fromJson(
        json.decode(str) as Map<String, dynamic>?,
      );
    } catch (_) {
      return const ChangePasswordResponse();
    }
  }

  String toRawJson() => json.encode(toJson());

  factory ChangePasswordResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ChangePasswordResponse();
    return ChangePasswordResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : {},
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
