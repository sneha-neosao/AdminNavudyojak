import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:admin_navudyojak/src/core/extensions/integer_sizedbox_extension.dart';
import 'package:admin_navudyojak/src/core/theme/app_color.dart';

/// Header widget displaying circular logo badge and 'Reset Password' title.
class ResetPasswordHeaderWidget extends StatelessWidget {
  const ResetPasswordHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Circular Logo Badge
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.white,
            border: Border.all(
              color: AppColor.border.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.04),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(18.w),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        28.hS,

        // Reset Password Title
        Text(
          'Reset Password',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
            letterSpacing: -0.4,
          ),
          softWrap: true,
        ),
      ],
    );
  }
}
