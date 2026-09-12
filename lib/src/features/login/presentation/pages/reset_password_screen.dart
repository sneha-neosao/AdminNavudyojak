import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_navudyojak/src/core/extensions/integer_sizedbox_extension.dart';
import 'package:admin_navudyojak/src/core/theme/app_color.dart';
import 'package:admin_navudyojak/src/routes/app_route_path.dart';
import '../../widgets/reset_password_actions_widget.dart';
import '../../widgets/reset_password_header_widget.dart';
import '../../widgets/reset_password_input_widget.dart';

/// Screen for Reset Password adhering to Rule 1 (StatefulWidget & Lean Screen).
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleBackToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoute.login.path);
    }
  }

  void _handleResetPassword() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 20.h,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  40.hS,

                  // Circular Logo & Reset Password Header
                  const ResetPasswordHeaderWidget(),
                  32.hS,

                  // Form Inputs (New Password & Confirm New Password)
                  ResetPasswordInputWidget(
                    newPasswordController: _newPasswordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                  32.hS,

                  // Reset Password Button & Back to Login Link
                  ResetPasswordActionsWidget(
                    onResetPassword: _handleResetPassword,
                    onBackToLogin: _handleBackToLogin,
                  ),
                  20.hS,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
