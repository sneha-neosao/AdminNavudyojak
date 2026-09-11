import 'package:flutter/material.dart';

class SettingItemData {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const SettingItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });
}
