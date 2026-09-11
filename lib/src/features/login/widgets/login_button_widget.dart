import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/theme/app_color.dart';

class LoginButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const LoginButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: AppColor.pureWhite,
            disabledBackgroundColor: AppColor.primary.withValues(alpha: 0.7),
            elevation: 2,
            shadowColor: AppColor.primary.withValues(alpha: 0.35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: isLoading
              ? const CupertinoActivityIndicator(
                  color: AppColor.white,
                  radius: 10,
                )
              : Text(
                  'login.title'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: AppColor.white,
                  ),
                ),
        ),
      ),
    );
  }
}
