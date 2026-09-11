import 'dart:async';
import 'package:admin_navudyojak/src/features/widgets/app_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_navudyojak/src/configs/injector/injector_conf.dart';
import 'package:admin_navudyojak/src/core/extensions/integer_sizedbox_extension.dart';
import 'package:admin_navudyojak/src/core/localization/app_localizations.dart';
import 'package:admin_navudyojak/src/features/login/bloc/auth_login_bloc/auth_login_bloc.dart';
import 'package:admin_navudyojak/src/routes/app_route_path.dart';
import '../../widgets/splash_background_pattern_widget.dart';
import '../../widgets/splash_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _authCheckDone = false;
  bool _isTimerFinished = false;
  bool _hasNavigated = false;
  AuthLoginState? _authState;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTimerFinished = true;
        });
        _navigateIfReady();
      }
    });
  }

  void _navigateIfReady() {
    if (_authCheckDone && _isTimerFinished && _authState != null && !_hasNavigated) {
      _hasNavigated = true;
      if (_authState is AuthCheckSignInStatusSuccessState) {
        context.go(AppRoute.home.path);
      } else {
        context.go(AppRoute.login.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color baseBackground = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.onSurface;
    final Color accentColor = theme.colorScheme.primary;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthLoginBloc>(
          create: (_) =>
              getIt<AuthLoginBloc>()..add(AuthCheckSignInStatusEvent()),
        ),
      ],
      child: BlocListener<AuthLoginBloc, AuthLoginState>(
        listenWhen: (_, current) =>
            current is AuthCheckSignInStatusSuccessState ||
            current is AuthCheckSignInStatusFailureState,
        listener: (context, state) {
          if (mounted) {
            setState(() {
              _authCheckDone = true;
              _authState = state;
            });
            _navigateIfReady();
          }
        },
        child: Scaffold(
          backgroundColor: baseBackground,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [theme.scaffoldBackgroundColor, theme.cardColor],
              ),
            ),
            child: Stack(
              children: [
                // Abstract Background Patterns
                const SplashBackgroundPatternWidget(),

                // Main Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SplashLogoWidget(isDark: isDark)
                          .animate()
                          .fade(duration: 800.ms)
                          .scale(
                            delay: 200.ms,
                            duration: 800.ms,
                            curve: Curves.easeOutQuart,
                          )
                          .shimmer(
                            delay: 1.5.seconds,
                            duration: 1.5.seconds,
                            color: accentColor.withValues(alpha: 0.2),
                          ),
                    ],
                  ),
                ),

                // Bottom loading status
                Positioned(
                  bottom: 60.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppLoaderWidget(radius: 12),
                        12.hS,
                        Text(
                          context.tr('splash.starting_app'),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: textColor.withValues(alpha: 0.3),
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fade(delay: 1.5.seconds),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
