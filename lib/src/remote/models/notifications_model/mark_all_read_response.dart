import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Null-safe response model for the Mark All As Read API adhering to Rule 12.
class MarkAllNotificationsReadResponse extends Equatable {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? data;
  final dynamic errors;

  const MarkAllNotificationsReadResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory MarkAllNotificationsReadResponse.fromRawJson(String str) {
    try {
      return MarkAllNotificationsReadResponse.fromJson(
        json.decode(str) as Map<String, dynamic>?,
      );
    } catch (_) {
      return const MarkAllNotificationsReadResponse();
    }
  }

  String toRawJson() => json.encode(toJson());

  factory MarkAllNotificationsReadResponse.fromJson(
      Map<String, dynamic>? json) {
    if (json == null) return const MarkAllNotificationsReadResponse();
    return MarkAllNotificationsReadResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : null,
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
