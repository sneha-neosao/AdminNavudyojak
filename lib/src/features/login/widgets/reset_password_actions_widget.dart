import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:admin_navudyojak/src/core/extensions/integer_sizedbox_extension.dart';
import 'package:admin_navudyojak/src/core/theme/app_color.dart';

/// Actions widget containing the Reset Password button and Back to Login link.
class ResetPasswordActionsWidget extends StatelessWidget {
  final VoidCallback? onResetPassword;
  final VoidCallback? onBackToLogin;

  const ResetPasswordActionsWidget({
    super.key,
    this.onResetPassword,
    this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary Reset Password Button
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: onResetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.pureWhite,
              elevation: 1.5,
              shadowColor: AppColor.primary.withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              'Reset Password',
              style: TextStyle(
                fontSize: 15.5.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.pureWhite,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        28.hS,

        // Back to Login Link
        Center(
          child: TextButton(
            onPressed: onBackToLogin,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Back to Login',
              style: TextStyle(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.charcoal,
                decoration: TextDecoration.underline,
                decorationColor: AppColor.charcoal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
