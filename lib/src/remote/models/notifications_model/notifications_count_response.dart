import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Null-safe model representing the Notifications Count API response adhering to Rule 12.
class NotificationsCountResponse extends Equatable {
  final bool? success;
  final String? message;
  final NotificationsCountData? data;
  final dynamic errors;

  const NotificationsCountResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory NotificationsCountResponse.fromRawJson(String str) {
    try {
      return NotificationsCountResponse.fromJson(
        json.decode(str) as Map<String, dynamic>?,
      );
    } catch (_) {
      return const NotificationsCountResponse();
    }
  }

  String toRawJson() => json.encode(toJson());

  factory NotificationsCountResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NotificationsCountResponse();
    return NotificationsCountResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? NotificationsCountData.fromJson(
              json['data'] as Map<String, dynamic>?,
            )
          : null,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
        'errors': errors,
      };

  @override
  List<Object?> get props => [success, message, data, errors];
}

class NotificationsCountData extends Equatable {
  final int allCount;
  final int unreadCount;
  final int readCount;

  const NotificationsCountData({
    this.allCount = 0,
    this.unreadCount = 0,
    this.readCount = 0,
  });

  factory NotificationsCountData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NotificationsCountData();
    return NotificationsCountData(
      allCount: json['all_count'] as int? ?? 0,
      unreadCount: json['unread_count'] as int? ?? 0,
      readCount: json['read_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'all_count': allCount,
        'unread_count': unreadCount,
        'read_count': readCount,
      };

  @override
  List<Object?> get props => [allCount, unreadCount, readCount];
}
