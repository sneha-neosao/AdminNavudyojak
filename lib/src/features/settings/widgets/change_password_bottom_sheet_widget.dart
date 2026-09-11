import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';

class ChangePasswordBottomSheetWidget extends StatefulWidget {
  final ValueChanged<String>? onSubmit;

  const ChangePasswordBottomSheetWidget({super.key, this.onSubmit});

  /// Static helper to display the Change Password Modal Bottom Sheet
  static Future<void> show(
    BuildContext context, {
    ValueChanged<String>? onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      barrierColor: AppColor.black.withValues(alpha: 0.5),
      builder: (sheetContext) =>
          ChangePasswordBottomSheetWidget(onSubmit: onSubmit),
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

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;

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

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final newPassword = _passwordController.text.trim();

      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pop();
        widget.onSubmit?.call(newPassword);

        AppSnackBarWidget.show(
          context,
          message: 'Password changed successfully',
          type: ToastType.success,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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

              // Field 1: Enter password
              _buildPasswordField(
                controller: _passwordController,
                label: 'Enter password',
                hintText: 'Enter new password',
                isObscured: _isPasswordObscured,
                onToggleVisibility: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
                validator: (val) {
                  final text = val?.trim() ?? _passwordController.text.trim();
                  if (text.isEmpty) {
                    return 'Please enter password';
                  }
                  if (text.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              16.hS,

              // Field 2: Re-enter password
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Re-enter password',
                hintText: 'Re-enter new password',
                isObscured: _isConfirmPasswordObscured,
                onToggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                  });
                },
                validator: (val) {
                  final text =
                      val?.trim() ?? _confirmPasswordController.text.trim();
                  if (text.isEmpty) {
                    return 'Please re-enter password';
                  }
                  if (text != _passwordController.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              26.hS,

              // Change Password Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
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
                  child: _isLoading
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
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.charcoal,
          ),
          softWrap: true,
        ),
        8.hS,
        TextFormField(
          controller: controller,
          obscureText: isObscured,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            color: AppColor.black,
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w600,
          ),
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColor.slateGrey.withValues(alpha: 0.65),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.only(
                left: 10.w,
                right: 12.w,
                top: 7.h,
                bottom: 7.h,
              ),
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColor.avatarBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: AppColor.primary,
                  size: 20.sp,
                ),
              ),
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                isObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColor.slateGrey,
                size: 20.sp,
              ),
            ),
            filled: true,
            fillColor: AppColor.pureWhite,
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 16.w,
            ),
            errorStyle: TextStyle(
              fontSize: 11.5.sp,
              color: AppColor.brightRed,
              height: 1.2,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: AppColor.metricCardBorder,
                width: 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: AppColor.metricCardBorder,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColor.primary, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: AppColor.brightRed,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: AppColor.brightRed,
                width: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
