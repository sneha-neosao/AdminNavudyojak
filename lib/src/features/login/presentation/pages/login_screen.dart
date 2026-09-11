import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_navudyojak/src/configs/injector/injector_conf.dart';
import 'package:admin_navudyojak/src/core/extensions/integer_sizedbox_extension.dart';
import 'package:admin_navudyojak/src/core/session/session_manager.dart';
import 'package:admin_navudyojak/src/core/theme/app_color.dart';
import 'package:admin_navudyojak/src/features/widgets/app_snackbar_widget.dart';
import 'package:admin_navudyojak/src/routes/app_route_path.dart';
import '../../bloc/auth_login_bloc/auth_login_bloc.dart';
import '../../bloc/auth_login_form_bloc/auth_login_form_bloc.dart';
import '../../widgets/login_button_widget.dart';
import '../../widgets/login_header_widget.dart';
import '../../widgets/login_input_widget.dart';
import '../../widgets/login_remember_forgot_widget.dart';
import '../../widgets/wave_background_painter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await SessionManager.getSavedCredentials();
    if (credentials != null && mounted) {
      setState(() {
        _emailController.text = credentials['username'] ?? '';
        _passwordController.text = credentials['password'] ?? '';
        _rememberMe = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Dual-BLoC submission adhering to Rule 13
  void _login(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    final authForm = context.read<AuthLoginFormBloc>().state;
    final email = authForm.email.trim().isNotEmpty
        ? authForm.email.trim()
        : _emailController.text.trim();
    final password = authForm.password.trim().isNotEmpty
        ? authForm.password.trim()
        : _passwordController.text.trim();

    context.read<AuthLoginBloc>().add(
          AuthLoginEvent(email, password),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthLoginBloc>(create: (_) => getIt<AuthLoginBloc>()),
        BlocProvider<AuthLoginFormBloc>(
            create: (_) => getIt<AuthLoginFormBloc>()),
      ],
      child: Builder(
        builder: (context) {
          return BlocConsumer<AuthLoginBloc, AuthLoginState>(
            listener: (context, state) async {
              if (state is AuthLoginFailureState) {
                AppSnackBarWidget.show(
                  context,
                  message: state.message,
                  type: ToastType.error,
                );
              } else if (state is AuthLoginSuccessState) {
                if (_rememberMe) {
                  await SessionManager.saveCredentials(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                }
                if (context.mounted) {
                  AppSnackBarWidget.show(
                    context,
                    message: state.data.message?.isNotEmpty == true
                        ? state.data.message!
                        : 'login.success_msg'.tr(),
                    type: ToastType.success,
                  );
                  context.go(AppRoute.home.path);
                }
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoginLoadingState;

              return Scaffold(
                body: Stack(
                  children: [
                    // Wave Background
                    Positioned.fill(
                      child: CustomPaint(
                        painter: WaveBackgroundPainter(
                          primaryColor: AppColor.secondary,
                          secondaryColor: AppColor.primary,
                          isDark: isDark,
                        ),
                      ),
                    ),

                    // Scrollable Lean Form Content
                    SafeArea(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 20.0,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 440),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Header Widget
                                    const LoginHeaderWidget(),
                                    36.hS,

                                    // Card Wrapper
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'login.title'.tr(),
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        6.hS,
                                        Text(
                                          'login.subtitle'.tr(),
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: theme.colorScheme
                                                .onSurfaceVariant,
                                            fontSize: 13,
                                          ),
                                        ),
                                        24.hS,

                                        // Encapsulated Form Inputs
                                        LoginInputWidget(
                                          emailController: _emailController,
                                          passwordController:
                                              _passwordController,
                                        ),
                                        16.hS,

                                        // Remember Me & Forgot Password
                                        LoginRememberForgotWidget(
                                          rememberMe: _rememberMe,
                                          onRememberMeChanged: (val) {
                                            setState(() {
                                              _rememberMe = val ?? false;
                                            });
                                          },
                                        ),
                                        28.hS,

                                        // Primary Login Button
                                        LoginButtonWidget(
                                          onPressed: () => _login(context),
                                          isLoading: isLoading,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
