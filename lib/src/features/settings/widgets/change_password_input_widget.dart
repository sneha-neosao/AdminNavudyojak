import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../profile/bloc/change_password_form_bloc/change_password_form_bloc.dart';

class ChangePasswordInputWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String>? onPasswordChanged;
  final ValueChanged<String>? onConfirmPasswordChanged;

  const ChangePasswordInputWidget({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    this.onPasswordChanged,
    this.onConfirmPasswordChanged,
  });

  @override
  State<ChangePasswordInputWidget> createState() =>
      _ChangePasswordInputWidgetState();
}

class _ChangePasswordInputWidgetState extends State<ChangePasswordInputWidget> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field 1: Enter Password
        _buildPasswordField(
          controller: widget.passwordController,
          label: 'Enter password',
          hintText: 'Enter new password',
          isObscured: _isPasswordObscured,
          onToggleVisibility: () {
            setState(() {
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
          onChanged: (val) {
            context.read<ChangePasswordFormBloc>().add(
              ChangePasswordPasswordChangedEvent(val),
            );
            widget.onPasswordChanged?.call(val);
          },
          validator: (val) {
            final text = val?.trim() ?? widget.passwordController.text.trim();
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

        // Field 2: Re-enter Password
        _buildPasswordField(
          controller: widget.confirmPasswordController,
          label: 'Re-enter password',
          hintText: 'Re-enter new password',
          isObscured: _isConfirmPasswordObscured,
          onToggleVisibility: () {
            setState(() {
              _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
            });
          },
          onChanged: (val) {
            context.read<ChangePasswordFormBloc>().add(
              ChangePasswordConfirmChangedEvent(val),
            );
            widget.onConfirmPasswordChanged?.call(val);
          },
          validator: (val) {
            final text =
                val?.trim() ?? widget.confirmPasswordController.text.trim();
            if (text.isEmpty) {
              return 'Please re-enter password';
            }
            if (text != widget.passwordController.text.trim()) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
    required ValueChanged<String> onChanged,
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
          onChanged: onChanged,
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
