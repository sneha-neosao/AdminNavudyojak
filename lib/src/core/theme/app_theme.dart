import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';
import 'app_font.dart';

/// utility class to define the app theme
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: const Color(0xFF5C4893),
      secondary: const Color(0xFF9B7ED9),
      surface: const Color(0xFFF3F1F8),
      onSurface: const Color(0xFF232323),
      onSurfaceVariant: const Color(0xFF6F6F6F),
      outline: const Color(0xFFE5E7EB),
      error: const Color(0xFFB3261E),
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      useMaterial3: true,
      cardColor: const Color(0xFFF8F9FA),
      dividerColor: const Color(0xFFE0E0E0),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFF8F9FA),
        elevation: 2,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: const Color(0xFF6750A4),
      secondary: const Color(0xFF03DAC6),
      surface: const Color(0xFF1E1E1E),
      onSurface: const Color(0xFFFFFFFF),
      onSurfaceVariant: const Color(0xFFB3B3B3),
      outline: const Color(0xFF2C2C2C),
      error: const Color(0xFFCF6679),
    );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF22242A),
      useMaterial3: true,
      cardColor: const Color(0xFF2B2D34),
      dividerColor: const Color.fromARGB(255, 88, 88, 88),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF22242A),
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }

  static ThemeData data(bool isDark) {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,

      primaryColor: AppColor.primary,

      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: AppColor.primary,
        onPrimary: Colors.white,
        secondary: AppColor.secondary,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: AppColor.card,
        onSurface: AppColor.black,
      ),

      scaffoldBackgroundColor:
      isDark ? const Color(0xFF1C1C1C) : AppColor.pureWhite,

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.black,
        centerTitle: true,
      ),

      cardColor: AppColor.card,

      dividerColor: AppColor.border,

      iconTheme: const IconThemeData(
        color: AppColor.primary,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColor.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColor.primary,
            width: 2,
          ),
        ),
      ),

      // Keep your existing ElevatedButtonTheme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 61.h),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
          textStyle: AppFont.bold.s17,
        ),
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: AppFont.family,
      textTheme: TextTheme(
        bodySmall: AppFont.normal.s12.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        bodyMedium: AppFont.normal.s14.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        bodyLarge: AppFont.normal.s16.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        headlineSmall: AppFont.bold.s12.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        headlineMedium: AppFont.bold.s16.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        headlineLarge: AppFont.bold.s18.copyWith(
          color: isDark ? Colors.white : Colors.black,
        ),
        displaySmall: AppFont.bold.s22.copyWith(
          color: isDark ? Colors.white : Colors.black,
          height: 22 / 22,
        ),
        displayMedium: AppFont.bold.s25.copyWith(
          color: isDark ? Colors.white : Colors.black,
          height: 22 / 31,
        ),
        displayLarge: AppFont.bold.s30.copyWith(
          color: isDark ? Colors.white : Colors.black,
          height: 22 / 30,
        ),
      ),
    );
  }
}