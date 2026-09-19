import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_navudyojak/src/configs/injector/injector_conf.dart';
import 'package:admin_navudyojak/src/core/extensions/integer_sizedbox_extension.dart';
import 'package:admin_navudyojak/src/core/theme/app_color.dart';
import 'package:admin_navudyojak/src/features/login/bloc/reset_password_bloc/reset_password_bloc.dart';
import 'package:admin_navudyojak/src/features/login/bloc/reset_password_form_bloc/reset_password_form_bloc.dart';
import 'package:admin_navudyojak/src/features/login/bloc/verify_reset_token_bloc/verify_reset_token_bloc.dart';
import 'package:admin_navudyojak/src/features/widgets/app_snackbar_widget.dart';
import 'package:admin_navudyojak/src/routes/app_route_path.dart';
import '../../widgets/reset_password_actions_widget.dart';
import '../../widgets/reset_password_header_widget.dart';
import '../../widgets/reset_password_input_widget.dart';

/// Screen for Reset Password adhering to Rule 1 (StatefulWidget & Lean Screen).
class ResetPasswordScreen extends StatefulWidget {
  final String? token;
  final String? companyCode;

  const ResetPasswordScreen({
    super.key,
    this.token,
    this.companyCode,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  late final VerifyResetTokenBloc _verifyResetTokenBloc;
  late final ResetPasswordBloc _resetPasswordBloc;
  late final ResetPasswordFormBloc _resetPasswordFormBloc;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _verifyResetTokenBloc = getIt<VerifyResetTokenBloc>();
    _resetPasswordBloc = getIt<ResetPasswordBloc>();
    _resetPasswordFormBloc = getIt<ResetPasswordFormBloc>();

    final token = widget.token;
    if (token != null && token.isNotEmpty) {
      _verifyResetTokenBloc.add(VerifyResetTokenSubmitEvent(token));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppSnackBarWidget.show(
            context,
            message: 'Invalid or missing reset password token',
            type: ToastType.error,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _verifyResetTokenBloc.close();
    _resetPasswordBloc.close();
    _resetPasswordFormBloc.close();
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
    primaryFocus?.unfocus();

    final token = widget.token ?? '';
    final password = _newPasswordController.text.trim();
    final passwordConfirm = _confirmPasswordController.text.trim();

    _resetPasswordBloc.add(
      SubmitResetPasswordEvent(
        token: token,
        password: password,
        passwordConfirm: passwordConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VerifyResetTokenBloc>.value(
          value: _verifyResetTokenBloc,
        ),
        BlocProvider<ResetPasswordBloc>.value(
          value: _resetPasswordBloc,
        ),
        BlocProvider<ResetPasswordFormBloc>.value(
          value: _resetPasswordFormBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<VerifyResetTokenBloc, VerifyResetTokenState>(
            listener: (context, state) {
              if (state is VerifyResetTokenFailureState) {
                AppSnackBarWidget.show(
                  context,
                  message: state.message,
                  type: ToastType.error,
                );
              } else if (state is VerifyResetTokenSuccessState) {
                AppSnackBarWidget.show(
                  context,
                  message: state.data.message?.isNotEmpty == true
                      ? state.data.message!
                      : 'Token is valid.',
                  type: ToastType.success,
                );
              }
            },
          ),
          BlocListener<ResetPasswordBloc, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordFailureState) {
                AppSnackBarWidget.show(
                  context,
                  message: state.message,
                  type: ToastType.error,
                );
              } else if (state is ResetPasswordSuccessState) {
                AppSnackBarWidget.show(
                  context,
                  message: state.data.message?.isNotEmpty == true
                      ? state.data.message!
                      : 'Password has been reset successfully. You can now login.',
                  type: ToastType.success,
                );
                context.go(AppRoute.login.path);
              }
            },
          ),
        ],
        child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
          builder: (context, resetState) {
            return BlocBuilder<VerifyResetTokenBloc, VerifyResetTokenState>(
              builder: (context, verifyState) {
                final isVerifying =
                    verifyState is VerifyResetTokenLoadingState;
                final isInvalidToken =
                    verifyState is VerifyResetTokenFailureState;
                final isResetLoading =
                    resetState is ResetPasswordLoadingState;

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

                              if (isVerifying) ...[
                                Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.h),
                                    child: Column(
                                      children: [
                                        const CircularProgressIndicator(
                                          color: AppColor.primary,
                                        ),
                                        12.hS,
                                        Text(
                                          'Verifying reset token...',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.charcoal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                16.hS,
                              ],

                              // Form Inputs (New Password & Confirm New Password)
                              ResetPasswordInputWidget(
                                newPasswordController:
                                    _newPasswordController,
                                confirmPasswordController:
                                    _confirmPasswordController,
                                onNewPasswordChanged: (val) {
                                  _resetPasswordFormBloc.add(
                                    ResetPasswordPasswordChangedEvent(val),
                                  );
                                },
                                onConfirmPasswordChanged: (val) {
                                  _resetPasswordFormBloc.add(
                                    ResetPasswordConfirmPasswordChangedEvent(
                                        val),
                                  );
                                },
                              ),
                              32.hS,

                              // Reset Password Button & Back to Login Link
                              ResetPasswordActionsWidget(
                                isLoading: isResetLoading,
                                onResetPassword:
                                    (isVerifying || isInvalidToken || isResetLoading)
                                        ? null
                                        : _handleResetPassword,
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
              },
            );
          },
        ),
      ),
    );
  }
}
