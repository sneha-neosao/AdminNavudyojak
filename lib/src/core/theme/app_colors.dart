import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // Core Seed Color
  static const Color seedColor = Color(0xFF6366F1); // Indigo

  // Brand Colors
  static const Color brandPurple = Color(0xFF6750A4); // Brand main purple
  static const Color brandOrage = Color(0xFFE46212); // Brand main orange

  // Lead Status Colors
  static const Color statusNew = Color(0xFF2563EB); // Blue
  static const Color statusAssigned = Color(0xFFD97706); // Amber
  static const Color statusInProgress = Color(0xFFF37A1D); // Orange
  static const Color statusDemoScheduled = Color(0xFF6750A4); // Purple
  static const Color statusConverted = Color(0xFF10B981); // Emerald/Green
  static const Color statusDropped = Color(0xFFEF4444); // Red

  // Social & Lead Source Colors
  static const Color sourceWhatsApp = Color(0xFF25D366);
  static const Color sourceLinkedIn = Color(0xFF0A66C2);
  static const Color sourceWebsite = Color(0xFF10B981);
  static const Color sourceFacebook = Color(0xFF1877F2);
  static const Color sourceInstagram = Color(0xFFE1306C);
  static const Color sourceManual = Color(0xFF8B5CF6);

  // Slate Neutral Palette
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Emerald Sub-palette (for success/conversion actions)
  static const Color emerald900 = Color(0xFF064E3B);
  static const Color emerald800 = Color(0xFF065F46);
  static const Color emerald700 = Color(0xFF047857);
  static const Color emerald400 = Color(0xFF34D399);
  static const Color emerald300 = Color(0xFF6EE7B7);
  static const Color emerald100 = Color(0xFFA7F3D0);
  static const Color emerald50 = Color(0xFFECFDF5);

  // Red Sub-palette (for warning/destructive actions)
  static const Color red900 = Color(0xFF7F1D1D);
  static const Color red800 = Color(0xFF991B1B);
  static const Color red700 = Color(0xFFB91C1C);
  static const Color red400 = Color(0xFFF87171);
  static const Color red300 = Color(0xFFFCA5A5);
  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red50 = Color(0xFFFEF2F2);

  // Dark Mode Palette (Premium Charcoal/Black)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
}
