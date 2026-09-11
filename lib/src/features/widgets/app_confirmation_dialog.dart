import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/extensions/integer_sizedbox_extension.dart';
import '../../core/theme/app_color.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color confirmBtnColor;
  final Color cancelBtnColor;
  final Color cancelTextColor;
  final bool isLoading;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Yes, Log Out',
    this.cancelText = 'Cancel',
    this.icon = Icons.logout_rounded,
    this.iconColor = AppColor.primary,
    this.iconBgColor = AppColor.avatarBg,
    this.confirmBtnColor = AppColor.primary,
    this.cancelBtnColor = AppColor.dialogCancelBg,
    this.cancelTextColor = AppColor.dialogCancelText,
    this.isLoading = false,
    required this.onConfirm,
    this.onCancel,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Yes, Log Out',
    String cancelText = 'Cancel',
    IconData icon = Icons.logout_rounded,
    Color iconColor = AppColor.primary,
    Color iconBgColor = AppColor.avatarBg,
    Color confirmBtnColor = AppColor.primary,
    Color cancelBtnColor = AppColor.dialogCancelBg,
    Color cancelTextColor = AppColor.dialogCancelText,
    bool isLoading = false,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: !isLoading,
      builder: (dialogContext) => PopScope(
        canPop: !isLoading,
        child: AppConfirmationDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          icon: icon,
          iconColor: iconColor,
          iconBgColor: iconBgColor,
          confirmBtnColor: confirmBtnColor,
          cancelBtnColor: cancelBtnColor,
          cancelTextColor: cancelTextColor,
          isLoading: isLoading,
          onConfirm: onConfirm,
          onCancel: onCancel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: AppColor.pureWhite,
      elevation: 8,
      shadowColor: AppColor.black.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
      child: Padding(
        padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Circular Icon Badge
            Container(
              width: 62.r,
              height: 62.r,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 26.sp,
                ),
              ),
            ),
            18.hS,

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
                letterSpacing: -0.2,
              ),
              softWrap: true,
            ),
            10.hS,

            // Message / Subtitle
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: AppColor.textSecondary,
                height: 1.45,
              ),
              softWrap: true,
            ),
            24.hS,

            // Buttons Row
            Row(
              children: [
                // Cancel Button (Soft Grey Pill)
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.of(context).pop(false);
                              onCancel?.call();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cancelBtnColor,
                        disabledBackgroundColor:
                            cancelBtnColor.withValues(alpha: 0.6),
                        elevation: 0,
                        shadowColor: AppColor.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        cancelText,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: cancelTextColor,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
                12.wS,

                // Confirm Button (Filled Purple/Accent Pill)
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmBtnColor,
                        disabledBackgroundColor:
                            confirmBtnColor.withValues(alpha: 0.7),
                        elevation: 0,
                        shadowColor: AppColor.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20.r,
                              width: 20.r,
                              child: const CupertinoActivityIndicator(
                                color: AppColor.pureWhite,
                              ),
                            )
                          : Text(
                              confirmText,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColor.pureWhite,
                              ),
                              softWrap: true,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
