import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_color.dart';
import '../../../routes/app_route_path.dart';
import '../../login/bloc/auth_login_bloc/auth_login_bloc.dart';
import '../../widgets/app_confirmation_dialog.dart';
import '../../widgets/app_snackbar_widget.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final BuildContext parentContext;
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData icon;

  const LogoutConfirmationDialog({
    super.key,
    required this.parentContext,
    this.title = 'Confirm Logout',
    this.message =
        'Are you sure you want to log out? You will need to sign in again to access logistics & orders.',
    this.confirmText = 'Yes, Log Out',
    this.cancelText = 'Cancel',
    this.icon = Icons.logout_rounded,
  });

  static Future<void> show({
    required BuildContext context,
    String title = 'Confirm Logout',
    String message =
        'Are you sure you want to log out? You will need to sign in again to access logistics & orders.',
    String confirmText = 'Yes, Log Out',
    String cancelText = 'Cancel',
    IconData icon = Icons.logout_rounded,
  }) {
    final authBloc = context.read<AuthLoginBloc>();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: authBloc,
        child: LogoutConfirmationDialog(
          parentContext: context,
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
          icon: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthLoginBloc, AuthLoginState>(
      listener: (dialogContext, state) {
        if (state is AuthLogoutSuccessState) {
          // 1. Close alert dialogue
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }

          // 2. Show success snackbar and navigate to login screen
          if (parentContext.mounted) {
            AppSnackBarWidget.show(
              parentContext,
              message: state.data.message?.isNotEmpty == true
                  ? state.data.message!
                  : 'Logged out successfully',
              type: ToastType.success,
            );
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
          canPop: !isLoading,
          child: AppConfirmationDialog(
            title: title,
            message: message,
            confirmText: confirmText,
            cancelText: cancelText,
            icon: icon,
            iconColor: AppColor.primary,
            iconBgColor: AppColor.avatarBg,
            confirmBtnColor: AppColor.primary,
            cancelBtnColor: AppColor.dialogCancelBg,
            cancelTextColor: AppColor.dialogCancelText,
            isLoading: isLoading,
            onConfirm: () {
              dialogContext.read<AuthLoginBloc>().add(AuthLogoutEvent());
            },
          ),
        );
      },
    );
  }
}
