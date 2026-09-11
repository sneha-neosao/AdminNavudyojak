import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Null-safe response model for Mark Single Notification As Read API adhering to Rule 12.
class MarkNotificationReadResponse extends Equatable {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? data;
  final dynamic errors;

  const MarkNotificationReadResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory MarkNotificationReadResponse.fromRawJson(String str) {
    try {
      return MarkNotificationReadResponse.fromJson(
        json.decode(str) as Map<String, dynamic>?,
      );
    } catch (_) {
      return const MarkNotificationReadResponse();
    }
  }

  String toRawJson() => json.encode(toJson());

  factory MarkNotificationReadResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const MarkNotificationReadResponse();
    return MarkNotificationReadResponse(
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
