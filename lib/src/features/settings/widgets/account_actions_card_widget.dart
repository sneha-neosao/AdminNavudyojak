import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../profile/bloc/profile_details_bloc/profile_details_bloc.dart';
import '../../widgets/app_snackbar_widget.dart';
import 'account_confirmation_dialog.dart';
import 'change_password_bottom_sheet_widget.dart';
import 'logout_confirmation_dialog.dart';

class AccountActionsCardWidget extends StatelessWidget {
  final VoidCallback? onChangePasswordTap;

  const AccountActionsCardWidget({super.key, this.onChangePasswordTap});

  void _onChangePasswordTap(BuildContext context) {
    if (onChangePasswordTap != null) {
      onChangePasswordTap!();
      return;
    }
    String userId = '';
    try {
      final profileState = context.read<ProfileDetailsBloc>().state;
      if (profileState is ProfileDetailsSuccessState) {
        userId = profileState.data.data?.id ?? '';
      }
    } catch (_) {}

    ChangePasswordBottomSheetWidget.show(context, userId: userId);
  }

  void _onLogoutTap(BuildContext context) {
    LogoutConfirmationDialog.show(context: context);
  }

  void _onDeleteAccountTap(BuildContext context) {
    AccountConfirmationDialog.show(
      context: context,
      title: 'Delete account',
      message: 'Are you sure you want to permanently delete your account? All your data will be removed and this action cannot be undone.',
      confirmText: 'Delete account',
      cancelText: 'Cancel',
      icon: Icons.delete_forever_rounded,
      iconColor: AppColor.brightRed,
      iconBgColor: AppColor.brightRed.withValues(alpha: 0.1),
      confirmBtnColor: AppColor.brightRed,
      onConfirm: () {
        AppSnackBarWidget.show(
          context,
          message: 'Account deletion request submitted',
          type: ToastType.warning,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColor.metricCardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'Account',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
            softWrap: true,
          ),
          4.hS,
          Text(
            'Session and security controls',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
            ),
            softWrap: true,
          ),
          16.hS,

          // 1. Change Password Tile
          _buildActionTile(
            context: context,
            theme: theme,
            title: 'Change password',
            subtitle: 'Update your account login password',
            icon: Icons.lock_outline_rounded,
            iconColor: AppColor.cockpitOrange,
            iconBgColor: AppColor.avatarBg,
            borderColor: AppColor.metricCardBorder,
            isDestructive: false,
            isLoading: false,
            onTap: () => _onChangePasswordTap(context),
          ),
          12.hS,

          // 2. Logout Tile
          _buildActionTile(
            context: context,
            theme: theme,
            title: 'Log out',
            subtitle: 'Sign out of your account session',
            icon: Icons.logout_rounded,
            iconColor: AppColor.cockpitOrange,
            iconBgColor: AppColor.avatarBg,
            borderColor: AppColor.metricCardBorder,
            isDestructive: false,
            isLoading: false,
            onTap: () => _onLogoutTap(context),
          ),
          12.hS,

          // 3. Delete Account Tile
          _buildActionTile(
            context: context,
            theme: theme,
            title: 'Delete account',
            subtitle: 'Permanently remove your account and data',
            icon: Icons.delete_outline_rounded,
            iconColor: AppColor.brightRed,
            iconBgColor: AppColor.brightRed.withValues(alpha: 0.08),
            borderColor: AppColor.brightRed.withValues(alpha: 0.25),
            isDestructive: true,
            onTap: () => _onDeleteAccountTap(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required ThemeData theme,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Color borderColor,
    required bool isDestructive,
    bool isLoading = false,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.1),
      ),
      child: Material(
        color: AppColor.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: isLoading ? null : onTap,
          splashColor: isDestructive
              ? AppColor.brightRed.withValues(alpha: 0.1)
              : AppColor.orangeTint2.withValues(alpha: 0.5),
          highlightColor: isDestructive
              ? AppColor.brightRed.withValues(alpha: 0.05)
              : AppColor.orangeTint2.withValues(alpha: 0.3),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                // Leading Icon in round container
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, size: 20.sp, color: iconColor),
                  ),
                ),
                14.wS,

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                          color: isDestructive
                              ? AppColor.brightRed
                              : AppColor.black,
                        ),
                        softWrap: true,
                      ),
                      2.hS,
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: isDestructive
                              ? AppColor.brightRed.withValues(alpha: 0.7)
                              : AppColor.textSecondary,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),

                // Trailing Widget
                if (isLoading)
                  CupertinoActivityIndicator(color: iconColor, radius: 9.r)
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: isDestructive
                        ? AppColor.brightRed.withValues(alpha: 0.6)
                        : AppColor.slateGrey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
