import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../widgets/app_confirmation_dialog.dart';
import '../../../widgets/app_snackbar_widget.dart';
import '../../bloc/approve_pending_advance_bloc/approve_pending_advance_bloc.dart';
import '../../bloc/pending_advance_bookings_bloc/pending_advance_bookings_bloc.dart';

class ApproveAdvanceConfirmationDialog extends StatelessWidget {
  final BuildContext parentContext;
  final String bookingId;
  final String bookingCode;
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final IconData icon;

  const ApproveAdvanceConfirmationDialog({
    super.key,
    required this.parentContext,
    required this.bookingId,
    this.bookingCode = '',
    this.title = 'Approve Advance',
    this.message = 'Are you sure you want to approve this pending advance payment?',
    this.confirmText = 'Approve',
    this.cancelText = 'Cancel',
    this.icon = Icons.check_circle_outline_rounded,
  });

  static Future<void> show({
    required BuildContext context,
    required String bookingId,
    String bookingCode = '',
    String title = 'Approve Advance',
    String? message,
    String confirmText = 'Approve',
    String cancelText = 'Cancel',
    IconData icon = Icons.check_circle_outline_rounded,
  }) {
    final approveBloc = context.read<ApprovePendingAdvanceBloc>();
    final defaultMessage = bookingCode.isNotEmpty
        ? 'Are you sure you want to approve the pending advance payment for booking $bookingCode?'
        : 'Are you sure you want to approve this pending advance payment?';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: approveBloc,
        child: ApproveAdvanceConfirmationDialog(
          parentContext: context,
          bookingId: bookingId,
          bookingCode: bookingCode,
          title: title,
          message: message ?? defaultMessage,
          confirmText: confirmText,
          cancelText: cancelText,
          icon: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApprovePendingAdvanceBloc, ApprovePendingAdvanceState>(
      listener: (dialogContext, state) {
        if (state is ApprovePendingAdvanceSuccessState) {
          // 1. Close alert dialog
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }

          // 2. Show success toast and refresh list API
          if (parentContext.mounted) {
            AppSnackBarWidget.show(
              parentContext,
              message: state.data.message?.isNotEmpty == true
                  ? state.data.message!
                  : 'Advance payment approved successfully',
              type: ToastType.success,
            );
            parentContext
                .read<PendingAdvanceBookingsBloc>()
                .add(RefreshPendingAdvanceBookingsEvent());
          }
        } else if (state is ApprovePendingAdvanceFailureState) {
          // 1. Close alert dialog
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }

          // 2. Show error toast
          if (parentContext.mounted) {
            AppSnackBarWidget.show(
              parentContext,
              message: state.message.isNotEmpty
                  ? state.message
                  : 'Failed to approve booking advance',
              type: ToastType.error,
            );
          }
        }
      },
      builder: (dialogContext, state) {
        final isLoading = state is ApprovePendingAdvanceLoadingState &&
            state.bookingId == bookingId;

        return PopScope(
          canPop: !isLoading,
          child: AppConfirmationDialog(
            title: title,
            message: message,
            confirmText: confirmText,
            cancelText: cancelText,
            icon: icon,
            iconColor: AppColor.primary,
            iconBgColor: AppColor.primary.withValues(alpha: 0.1),
            confirmBtnColor: AppColor.primary,
            cancelBtnColor: AppColor.dialogCancelBg,
            cancelTextColor: AppColor.dialogCancelText,
            isLoading: isLoading,
            onConfirm: () {
              dialogContext.read<ApprovePendingAdvanceBloc>().add(
                    ApprovePendingAdvanceSubmitEvent(bookingId),
                  );
            },
          ),
        );
      },
    );
  }
}
