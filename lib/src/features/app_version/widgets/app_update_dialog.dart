import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';

class AppUpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String updateUrl;
  final bool showCancelButton;
  final String title;
  final String? message;
  final VoidCallback? onCancel;

  const AppUpdateDialog({
    super.key,
    required this.currentVersion,
    required this.updateUrl,
    required this.showCancelButton,
    this.title = 'Update Available',
    this.message,
    this.onCancel,
  });

  /// Shows the non-dismissible App Update dialog.
  /// If [showCancelButton] is false, Cancel button is hidden and dialog cannot be dismissed.
  static Future<void> show({
    required BuildContext context,
    required String currentVersion,
    required String updateUrl,
    required bool showCancelButton,
    String title = 'Update Available',
    String? message,
    VoidCallback? onCancel,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) => AppUpdateDialog(
        currentVersion: currentVersion,
        updateUrl: updateUrl,
        showCancelButton: showCancelButton,
        title: title,
        message: message,
        onCancel: onCancel,
      ),
    );
  }

  Future<void> _launchUpdateUrl(BuildContext context) async {
    final cleanUrl = updateUrl.trim();
    if (cleanUrl.isEmpty) {
      if (context.mounted) {
        AppSnackBarWidget.show(
          context,
          message: 'Update URL is not available.',
          type: ToastType.error,
        );
      }
      return;
    }

    final uri = Uri.tryParse(cleanUrl);
    if (uri != null) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          await launchUrl(uri);
        }
      } catch (e) {
        if (context.mounted) {
          AppSnackBarWidget.show(
            context,
            message: 'Unable to open update link.',
            type: ToastType.error,
          );
        }
      }
    } else {
      if (context.mounted) {
        AppSnackBarWidget.show(
          context,
          message: 'Invalid update link provided.',
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final displayMessage =
        message ??
        (showCancelButton
            ? 'A newer version ($currentVersion) of the application is available with enhancements and improvements. Would you like to update now?'
            : 'A mandatory update ($currentVersion) is required to continue using the application. Please update to the latest version.');

    return PopScope(
      canPop: showCancelButton,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop && showCancelButton) {
          onCancel?.call();
        }
      },
      child: Dialog(
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
                decoration: const BoxDecoration(
                  color: AppColor.avatarBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.system_update_rounded,
                    color: AppColor.primary,
                    size: 28.sp,
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

              // Update Description Message
              Text(
                displayMessage,
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

              // Action Buttons Row
              if (showCancelButton)
                Row(
                  children: [
                    // Cancel Button (Closes dialog)
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onCancel?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.dialogCancelBg,
                            elevation: 0,
                            shadowColor: AppColor.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Cancel',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.dialogCancelText,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ),
                    ),
                    12.wS,

                    // Update Button (Launches updateUrl)
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () => _launchUpdateUrl(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            elevation: 0,
                            shadowColor: AppColor.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Update',
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
                )
              else
                // Mandatory update - Only Update button spanning full width
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () => _launchUpdateUrl(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      elevation: 0,
                      shadowColor: AppColor.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Update',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.pureWhite,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
