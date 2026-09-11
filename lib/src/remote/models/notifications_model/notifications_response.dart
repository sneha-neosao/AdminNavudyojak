import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../features/notifications/widgets/notification_item.dart';

class NotificationsResponse extends Equatable {
  final bool? success;
  final String? message;
  final NotificationsData? data;
  final dynamic errors;

  const NotificationsResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NotificationsResponse();
    return NotificationsResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? NotificationsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errors': errors,
    };
  }

  @override
  List<Object?> get props => [success, message, data, errors];
}

class NotificationsData extends Equatable {
  final List<NotificationModel> results;
  final NotificationPagination? pagination;

  const NotificationsData({
    this.results = const [],
    this.pagination,
  });

  factory NotificationsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NotificationsData();
    return NotificationsData(
      results: json['results'] != null && json['results'] is List
          ? (json['results'] as List)
              .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>?))
              .toList()
          : const [],
      pagination: json['pagination'] != null && json['pagination'] is Map<String, dynamic>
          ? NotificationPagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  @override
  List<Object?> get props => [results, pagination];
}

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final String type;
  final String? relatedEntityId;
  final String createdAt;

  const NotificationModel({
    this.id = '',
    this.title = '',
    this.body = '',
    this.isRead = false,
    this.type = '',
    this.relatedEntityId,
    this.createdAt = '',
  });

  factory NotificationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NotificationModel();
    return NotificationModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      type: json['type'] as String? ?? '',
      relatedEntityId: json['related_entity_id'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'is_read': isRead,
      'type': type,
      'related_entity_id': relatedEntityId,
      'created_at': createdAt,
    };
  }

  /// Converts this API model into the UI [NotificationItem]
  NotificationItem toNotificationItem() {
    NotificationType notifType;
    IconData icon;

    switch (type.toLowerCase()) {
      case 'order':
      case 'bulk_order':
        notifType = NotificationType.order;
        icon = Icons.local_shipping_outlined;
        break;
      case 'alert':
      case 'warning':
        notifType = NotificationType.alert;
        icon = Icons.warning_amber_rounded;
        break;
      case 'customer':
      case 'onboarding':
        notifType = NotificationType.customer;
        icon = Icons.person_add_alt_1_outlined;
        break;
      case 'follow_up':
        notifType = NotificationType.alert;
        icon = Icons.access_time_rounded;
        break;
      case 'system':
      default:
        notifType = NotificationType.system;
        icon = Icons.notifications_none_rounded;
        break;
    }

    return NotificationItem(
      id: id,
      title: title.isNotEmpty ? title : 'Notification',
      message: body,
      time: _formatTime(createdAt),
      type: notifType,
      isRead: isRead,
      icon: icon,
    );
  }

  String _formatTime(String rawDate) {
    if (rawDate.isEmpty) return '';
    try {
      final parsed = DateTime.parse(rawDate).toLocal();
      final now = DateTime.now();
      final diff = now.difference(parsed);

      if (diff.inMinutes < 1) {
        return 'Just now';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}h ago';
      } else if (diff.inDays == 1) {
        return 'Yesterday';
      } else if (diff.inDays < 7) {
        return '${diff.inDays}d ago';
      } else {
        return '${parsed.day} ${_getMonth(parsed.month)} ${parsed.year}';
      }
    } catch (_) {
      return rawDate;
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        isRead,
        type,
        relatedEntityId,
        createdAt,
      ];
}

class NotificationPagination extends Equatable {
  final int count;
  final int totalPages;
  final int currentPage;
  final int limit;

  const NotificationPagination({
    this.count = 0,
    this.totalPages = 1,
    this.currentPage = 1,
    this.limit = 10,
  });

  factory NotificationPagination.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NotificationPagination();
    return NotificationPagination(
      count: json['count'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 1,
      currentPage: json['current_page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'total_pages': totalPages,
      'current_page': currentPage,
      'limit': limit,
    };
  }

  @override
  List<Object?> get props => [count, totalPages, currentPage, limit];
}
