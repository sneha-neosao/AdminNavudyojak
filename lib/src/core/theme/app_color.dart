import 'package:flutter/material.dart';

/// utility class to define the app colors

class AppColor {
  /// Primary Theme Colors — Deep Purple
  static const Color primary = Color(0xFF5C4893);
  static const Color primaryDark = Color(0xFF4A3678);
  static const Color primaryLight = Color(0xFF8B72C2);
  static const Color primaryLight2 = Color(0xFF7A5FB8);

  /// Accent — Purple tones
  static const Color secondary = Color(0xFF9B7ED9);
  static const Color orangeTint = Color(0xFFE8DEFF);
  static const Color orangeTint2 = Color(0xFFF0EBFF);

  /// Backgrounds
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteDark = Color(0xFFFFFFFF);
  static const Color whiteShade = Color(0xFFFFFFFF);
  static const Color subCardBg = Color(0xFFF7F8FA);

  /// Text
  static const Color grey = Colors.grey;
  static const Color slateGrey = Color(0xFF7A869A);
  static const Color charcoal = Color(0xFF2E3E5C);
  static const Color black = Color(0xFF232323);
  static const Color textPrimary = Color(0xFF2B2B2B);
  static const Color textSecondary = Color(0xFF6F6F6F);

  /// Borders
  static const Color border = Color(0xFFD9D0F0);

  /// Disabled
  static const Color gray = Color(0xFFBDBDBD);

  /// Extra Theme Colors
  static const Color card = Color(0xFFFFFFFF);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color icon = Color(0xFF5C4893);
  static const Color darkOrange = Color(0xFF4A3678);

  /// Cockpit Card Colors — mapped to purple
  static const Color cockpitOrange = Color(0xFF5C4893);
  static const Color cockpitPill = Color(0xFF6B56A8);
  static const Color cockpitSubtitle = Color(0xFFD3C8F0);

  /// Metric Card Colors
  static const Color metricGreen = Color(0xFF15803D);
  static const Color metricCardBorder = Color(0xFFE5E7EB);
  static const Color metricCardBg = Color(0xFFFFFFFF);

  ///app api calls success and failure toast colors
  static const Color pendingBadgeRed = Color(0xFFD40924);
  static const Color customerBadgeGreen = Color(0xFF278733);
  static const Color avatarBg = Color(0xFFEDE8F8);
  static const Color brightRed = Color(0xFFE62222);
  // ignore: constant_identifier_names
  static const bright_red = Color(0xFFE62222); // alias for backward compat
  static const green = Color(0xFF188510);
  static const Color transparent = Colors.transparent;
}
