import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../configs/injector/injector_conf.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';
import '../bloc/forgot_password_bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_form_bloc/forgot_password_form_bloc.dart';
import 'forgot_password_input_widget.dart';

class ForgotPasswordBottomSheetWidget extends StatefulWidget {
  final String? initialEmail;
  final ValueChanged<String>? onSubmit;

  const ForgotPasswordBottomSheetWidget({
    super.key,
    this.initialEmail,
    this.onSubmit,
  });

  /// Static helper to display the Forgot Password Modal Bottom Sheet
  static Future<void> show(
    BuildContext context, {
    String? initialEmail,
    ValueChanged<String>? onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      barrierColor: AppColor.black.withValues(alpha: 0.5),
      builder: (sheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider<ForgotPasswordFormBloc>(
            create: (_) => getIt<ForgotPasswordFormBloc>(),
          ),
          BlocProvider<ForgotPasswordBloc>(
            create: (_) => getIt<ForgotPasswordBloc>(),
          ),
        ],
        child: ForgotPasswordBottomSheetWidget(
          initialEmail: initialEmail,
          onSubmit: onSubmit,
        ),
      ),
    );
  }

  @override
  State<ForgotPasswordBottomSheetWidget> createState() =>
      _ForgotPasswordBottomSheetWidgetState();
}

class _ForgotPasswordBottomSheetWidgetState
    extends State<ForgotPasswordBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      context.read<ForgotPasswordBloc>().add(SendForgotPasswordEvent(email));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccessState) {
          final email = _emailController.text.trim();
          Navigator.of(context).pop();

          widget.onSubmit?.call(email);

          AppSnackBarWidget.show(
            context,
            message: state.data.message?.isNotEmpty == true
                ? state.data.message!
                : 'Password reset link sent to $email',
            type: ToastType.success,
          );
        } else if (state is ForgotPasswordFailureState) {
          AppSnackBarWidget.show(
            context,
            message: state.message,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ForgotPasswordLoadingState;

        return Container(
          decoration: BoxDecoration(
            color: AppColor.pureWhite,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.r),
            ),
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
                  // Drag Handle / Pill
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
                    'Forgot Password?',
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
                    'Enter your email address to receive a recovery code / link.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textSecondary,
                      height: 1.35,
                    ),
                    softWrap: true,
                  ),
                  22.hS,

                  // Email Input Field
                  ForgotPasswordInputWidget(
                    controller: _emailController,
                  ),
                  26.hS,

                  // Send Reset Link Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _submit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.pureWhite,
                        disabledBackgroundColor:
                            AppColor.primary.withValues(alpha: 0.75),
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
                              'Send Reset Link',
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
