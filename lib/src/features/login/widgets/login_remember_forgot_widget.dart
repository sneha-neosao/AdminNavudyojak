import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:admin_navudyojak/src/core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

class LoginRememberForgotWidget extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback? onForgotPassword;

  const LoginRememberForgotWidget({
    super.key,
    required this.rememberMe,
    required this.onRememberMeChanged,
    this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: rememberMe,
                activeColor: AppColor.primary,
                side: BorderSide(
                  color: theme.dividerColor,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged: onRememberMeChanged,
              ),
            ),
            8.wS,
            Text(
              'login.remember_me'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onForgotPassword,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'login.forgot_password'.tr(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColor.primary,
            ),
          ),
        ),
      ],
    );
  }
}
