import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/extensions/string_validator_extension.dart';
import '../../../core/theme/app_color.dart';

class ForgotPasswordInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const ForgotPasswordInputWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          onChanged: onChanged,
          style: TextStyle(
            color: AppColor.black,
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w600,
          ),
          validator: (val) {
            if (validator != null) {
              return validator!(val);
            }
            final text = val?.trim() ?? '';
            if (text.isEmpty) {
              return 'Please enter your email address';
            }
            if (!text.isEmailValid) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'seema@gmail.com',
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
                  Icons.mail_outline_rounded,
                  color: AppColor.primary,
                  size: 20.sp,
                ),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColor.brightRed,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(
                color: AppColor.brightRed,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
