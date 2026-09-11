import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/injector/injector_conf.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../../routes/app_route_path.dart';
import '../../login/bloc/auth_login_bloc/auth_login_bloc.dart';
import '../../widgets/app_snackbar_widget.dart';

class MaintenanceModeDialog extends StatelessWidget {
  final BuildContext parentContext;
  final String title;
  final String message;
  final String exitText;
  final String logoutText;

  const MaintenanceModeDialog({
    super.key,
    required this.parentContext,
    this.title = 'Maintenance Mode',
    required this.message,
    this.exitText = 'Exit',
    this.logoutText = 'Logout',
  });

  /// Displays the non-dismissible Maintenance Mode alert dialog.
  static Future<void> show({
    required BuildContext context,
    String title = 'Maintenance Mode',
    String? message,
    String exitText = 'Exit',
    String logoutText = 'Logout',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) => BlocProvider(
        create: (_) => getIt<AuthLoginBloc>(),
        child: MaintenanceModeDialog(
          parentContext: context,
          title: title,
          message: (message != null && message.trim().isNotEmpty)
              ? message.trim()
              : 'Our system is currently undergoing scheduled maintenance. Please check back shortly.',
          exitText: exitText,
          logoutText: logoutText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthLoginBloc, AuthLoginState>(
      listener: (dialogContext, state) {
        if (state is AuthLogoutSuccessState) {
          // Close the dialog
          if (dialogContext.mounted) {
            Navigator.of(dialogContext, rootNavigator: true).pop();
          }

          // Navigate to login screen
          if (parentContext.mounted) {
            parentContext.go(AppRoute.login.path);
          }
        } else if (state is AuthLogoutFailureState) {
          if (parentContext.mounted) {
            AppSnackBarWidget.show(
              parentContext,
              message: state.message,
              type: ToastType.error,
            );
          }
        }
      },
      builder: (dialogContext, state) {
        final isLoading = state is AuthLogoutLoadingState;

        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: AppColor.pureWhite,
            elevation: 8,
            shadowColor: AppColor.black.withValues(alpha: 0.12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
            insetPadding: EdgeInsets.symmetric(
              horizontal: 28.w,
              vertical: 24.h,
            ),
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
                        Icons.construction_rounded,
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

                  // Maintenance Message
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

                  // Buttons Row: Exit and Logout
                  Row(
                    children: [
                      // Exit Button (Closes app)
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    SystemNavigator.pop();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.dialogCancelBg,
                              disabledBackgroundColor: AppColor.dialogCancelBg
                                  .withValues(alpha: 0.6),
                              elevation: 0,
                              shadowColor: AppColor.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              exitText,
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

                      // Logout Button (Calls Logout API, shows loader, navigates to Login on success)
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    dialogContext.read<AuthLoginBloc>().add(
                                      AuthLogoutEvent(),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              disabledBackgroundColor: AppColor.primary
                                  .withValues(alpha: 0.7),
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
                                    logoutText,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
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
          ),
        );
      },
    );
  }
}
