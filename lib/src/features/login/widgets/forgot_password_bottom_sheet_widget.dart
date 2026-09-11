import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';
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
      builder: (sheetContext) => ForgotPasswordBottomSheetWidget(
        initialEmail: initialEmail,
        onSubmit: onSubmit,
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
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();

      if (widget.onSubmit != null) {
        widget.onSubmit!(email);
      }

      AppSnackBarWidget.show(
        context,
        message: 'Password reset link sent to $email',
        type: ToastType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.pureWhite,
                    elevation: 1,
                    shadowColor: AppColor.primary.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
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
  }
}
