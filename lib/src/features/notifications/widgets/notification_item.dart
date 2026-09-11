import 'package:flutter/material.dart';

enum NotificationType {
  order,
  alert,
  customer,
  system,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;
  final IconData icon;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
    required this.icon,
  });
}
