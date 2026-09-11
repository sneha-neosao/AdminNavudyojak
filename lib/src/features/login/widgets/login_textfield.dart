import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_navudyojak/src/core/extensions/integer_sizedbox_extension.dart';
import 'package:admin_navudyojak/src/core/extensions/string_validator_extension.dart';
import 'package:admin_navudyojak/src/core/theme/app_color.dart';
import '../bloc/auth_login_form_bloc/auth_login_form_bloc.dart';

class LoginTextField<T> extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final bool isSecure;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool? readOnly;
  final TextCapitalization? textCapitalization;

  const LoginTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.isSecure = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.readOnly,
    this.textCapitalization,
  });

  @override
  State<LoginTextField<T>> createState() => _LoginTextFieldState<T>();
}

class _LoginTextFieldState<T> extends State<LoginTextField<T>> {
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formBloc = context.read<T>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColor.charcoal,
          ),
        ),
        4.hS,
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: widget.isSecure ? _isVisible : false,
          onChanged: widget.onChanged,
          style: const TextStyle(
            color: AppColor.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly ?? false,
          validator: (val) {
            if (formBloc is AuthLoginFormBloc) {
              final textVal = (val != null && val.isNotEmpty)
                  ? val
                  : (widget.controller?.text ?? '');
              final emailToCheck = textVal.isNotEmpty
                  ? textVal
                  : formBloc.state.email;
              final passwordToCheck = textVal.isNotEmpty
                  ? textVal
                  : formBloc.state.password;

              if (widget.label == "email".tr() && textVal.isEmpty) {
                return "please_enter_email".tr();
              } else if (widget.label == "email".tr() &&
                  !emailToCheck.isEmailValid) {
                return "please_enter_valid_email".tr();
              } else if (widget.label == "login_password_label".tr() &&
                  textVal.isEmpty) {
                return "please_enter_password".tr();
              } else if (widget.label == "login_password_label".tr() &&
                  !passwordToCheck.isPasswordValid) {
                return "please_enter_valid_password".tr();
              }
            }

            return widget.validator?.call(val);
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColor.slateGrey.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 10, right: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.prefixIcon,
                color: AppColor.primary,
                size: 20,
              ),
            ),
            suffixIcon: widget.isSecure
                ? IconButton(
                    onPressed: _toggleVisibility,
                    icon: Icon(
                      _isVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColor.slateGrey,
                    ),
                  )
                : null,
            filled: true,
            fillColor: AppColor.subCardBg,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            errorStyle: const TextStyle(
              fontSize: 11,
              color: AppColor.brightRed,
              height: 1.2,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColor.border, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColor.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: AppColor.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColor.brightRed, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColor.brightRed, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
