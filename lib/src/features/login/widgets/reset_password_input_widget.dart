import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:admin_navudyojak/src/core/extensions/integer_sizedbox_extension.dart';
import 'package:admin_navudyojak/src/core/theme/app_color.dart';

/// Form inputs container for Reset Password with independent visibility toggles.
class ResetPasswordInputWidget extends StatefulWidget {
  final TextEditingController? newPasswordController;
  final TextEditingController? confirmPasswordController;
  final ValueChanged<String>? onNewPasswordChanged;
  final ValueChanged<String>? onConfirmPasswordChanged;

  const ResetPasswordInputWidget({
    super.key,
    this.newPasswordController,
    this.confirmPasswordController,
    this.onNewPasswordChanged,
    this.onConfirmPasswordChanged,
  });

  @override
  State<ResetPasswordInputWidget> createState() =>
      _ResetPasswordInputWidgetState();
}

class _ResetPasswordInputWidgetState extends State<ResetPasswordInputWidget> {
  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // New Password Label
        Text(
          'New Password',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.charcoal,
          ),
          softWrap: true,
        ),
        8.hS,

        // New Password Input Field
        TextFormField(
          controller: widget.newPasswordController,
          obscureText: _isNewPasswordObscured,
          onChanged: widget.onNewPasswordChanged,
          style: TextStyle(
            color: AppColor.black,
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your password',
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
              onPressed: () {
                setState(() {
                  _isNewPasswordObscured = !_isNewPasswordObscured;
                });
              },
              icon: Icon(
                _isNewPasswordObscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColor.metricCardBorder,
                width: 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColor.metricCardBorder,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColor.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
        16.hS,

        // Confirm New Password Label
        Text(
          'Confirm New Password',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.charcoal,
          ),
          softWrap: true,
        ),
        8.hS,

        // Confirm New Password Input Field
        TextFormField(
          controller: widget.confirmPasswordController,
          obscureText: _isConfirmPasswordObscured,
          onChanged: widget.onConfirmPasswordChanged,
          style: TextStyle(
            color: AppColor.black,
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your password',
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
                  Icons.lock_reset_rounded,
                  color: AppColor.primary,
                  size: 20.sp,
                ),
              ),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                });
              },
              icon: Icon(
                _isConfirmPasswordObscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColor.metricCardBorder,
                width: 1.2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColor.metricCardBorder,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColor.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
