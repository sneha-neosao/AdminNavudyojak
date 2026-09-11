import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/injector/injector_conf.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../profile/bloc/change_password_bloc/change_password_bloc.dart';
import '../../profile/bloc/change_password_form_bloc/change_password_form_bloc.dart';
import '../../profile/bloc/profile_details_bloc/profile_details_bloc.dart';
import '../../widgets/app_snackbar_widget.dart';
import 'change_password_input_widget.dart';

class ChangePasswordBottomSheetWidget extends StatefulWidget {
  final String? userId;
  final ValueChanged<String>? onSubmit;

  const ChangePasswordBottomSheetWidget({
    super.key,
    this.userId,
    this.onSubmit,
  });

  /// Static helper to display the Change Password Modal Bottom Sheet
  static Future<void> show(
    BuildContext context, {
    String? userId,
    ValueChanged<String>? onSubmit,
  }) {
    // If userId not provided directly, try to extract from ProfileDetailsBloc
    String resolvedUserId = userId ?? '';
    if (resolvedUserId.isEmpty) {
      try {
        final profileState = context.read<ProfileDetailsBloc>().state;
        if (profileState is ProfileDetailsSuccessState) {
          resolvedUserId = profileState.data.data?.id ?? '';
        }
      } catch (_) {}
    }

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      barrierColor: AppColor.black.withValues(alpha: 0.5),
      builder: (sheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider<ChangePasswordFormBloc>(
            create: (_) => getIt<ChangePasswordFormBloc>(),
          ),
          BlocProvider<ChangePasswordBloc>(
            create: (_) => getIt<ChangePasswordBloc>(),
          ),
        ],
        child: ChangePasswordBottomSheetWidget(
          userId: resolvedUserId,
          onSubmit: onSubmit,
        ),
      ),
    );
  }

  @override
  State<ChangePasswordBottomSheetWidget> createState() =>
      _ChangePasswordBottomSheetWidgetState();
}

class _ChangePasswordBottomSheetWidgetState
    extends State<ChangePasswordBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final password = _passwordController.text.trim();
      final passwordConfirm = _confirmPasswordController.text.trim();

      final userId = widget.userId?.trim() ?? '';
      if (userId.isEmpty) {
        AppSnackBarWidget.show(
          context,
          message: 'Unable to identify user profile. Please try again.',
          type: ToastType.error,
        );
        return;
      }

      context.read<ChangePasswordBloc>().add(
        SubmitChangePasswordEvent(
          userId: userId,
          password: password,
          passwordConfirm: passwordConfirm,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccessState) {
          final newPassword = _passwordController.text.trim();
          Navigator.of(context).pop();

          widget.onSubmit?.call(newPassword);

          AppSnackBarWidget.show(
            context,
            message: state.data.message?.isNotEmpty == true
                ? state.data.message!
                : 'Password changed successfully.',
            type: ToastType.success,
          );
        } else if (state is ChangePasswordFailureState) {
          AppSnackBarWidget.show(
            context,
            message: state.message,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ChangePasswordLoadingState;

        return Container(
          decoration: BoxDecoration(
            color: AppColor.pureWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 12.h,
            bottom: bottomInset + 28.h,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 44.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: AppColor.metricCardBorder,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  20.hS,

                  // Title
                  Text(
                    'Change Password',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColor.black,
                      letterSpacing: -0.3,
                    ),
                    softWrap: true,
                  ),
                  8.hS,

                  // Subtitle
                  Text(
                    'Enter your new password and re-enter it to confirm.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textSecondary,
                      height: 1.35,
                    ),
                    softWrap: true,
                  ),
                  22.hS,

                  // Modular Input Widget adhering to Rule 13
                  ChangePasswordInputWidget(
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                  26.hS,

                  // Change Password Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.pureWhite,
                        disabledBackgroundColor: AppColor.primary.withValues(
                          alpha: 0.75,
                        ),
                        elevation: 1,
                        shadowColor: AppColor.primary.withValues(alpha: 0.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: isLoading
                          ? const CupertinoActivityIndicator(
                              color: AppColor.white,
                              radius: 10,
                            )
                          : Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColor.pureWhite,
                                letterSpacing: 0.2,
                              ),
                            ),
                    ),
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
