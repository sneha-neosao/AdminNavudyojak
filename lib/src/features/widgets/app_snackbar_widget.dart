import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

enum ToastType { success, error, info, warning }

class AppSnackBarWidget {
  static void show(
      BuildContext context, {
        required String message,
        ToastType type = ToastType.success,
        Duration duration = const Duration(seconds: 3),
      }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String displayMessage = message;
    final lowerMsg = message.toLowerCase();
    if (lowerMsg.contains('404') ||
        lowerMsg.contains('500') ||
        lowerMsg.contains('502') ||
        lowerMsg.contains('<html') ||
        lowerMsg.contains('<!doctype')) {
      displayMessage = 'Something went wrong. Please try again later.';
    }

    // Get color and icon based on type
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case ToastType.success:
        backgroundColor = AppColors.statusConverted;
        textColor = Colors.white;
        icon = Icons.check_circle_rounded;
        break;
      case ToastType.error:
        backgroundColor = AppColors.red700;
        textColor = Colors.white;
        icon = Icons.error_rounded;
        break;
      case ToastType.warning:
        backgroundColor = AppColors.statusAssigned;
        textColor = Colors.white;
        icon = Icons.warning_rounded;
        break;
      case ToastType.info:
        backgroundColor = AppColors.brandPurple;
        textColor = Colors.white;
        icon = Icons.info_rounded;
        break;
    }

    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: 90.h,
        left: 24.w,
        right: 24.w,
      ),
      duration: duration,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark ? theme.cardColor : backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? backgroundColor.withValues(alpha: 0.3)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: isDark ? backgroundColor : textColor, size: 20.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                displayMessage,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Remove current snackbar and present the new toast
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
