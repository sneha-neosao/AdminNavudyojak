import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:admin_navudyojak/src/core/extensions/integer_sizedbox_extension.dart';
import '../bloc/auth_login_form_bloc/auth_login_form_bloc.dart';
import 'login_textfield.dart';

class LoginInputWidget extends StatelessWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;

  const LoginInputWidget({
    super.key,
    this.emailController,
    this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final formBloc = context.read<AuthLoginFormBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mobile / Email Input
        LoginTextField<AuthLoginFormBloc>(
          controller: emailController,
          label: 'email'.tr(),
          hintText: 'enter_your_email'.tr(),
          prefixIcon: Icons.phone_iphone_rounded,
          onChanged: (val) {
            final trimmed = val.trim();
            formBloc.add(LoginFormEmailChangedEvent(trimmed));
          },
          keyboardType: TextInputType.emailAddress,
        ),
        16.hS,

        // Password Input
        LoginTextField<AuthLoginFormBloc>(
          controller: passwordController,
          label: 'login_password_label'.tr(),
          hintText: 'login_password_hint'.tr(),
          prefixIcon: Icons.lock_outline_rounded,
          onChanged: (val) {
            final trimmed = val.trim();
            formBloc.add(LoginFormPasswordChangedEvent(trimmed));
          },
          isSecure: true,
        ),
      ],
    );
  }
}
