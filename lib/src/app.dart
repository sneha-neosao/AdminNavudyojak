import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'configs/injector/injector.dart';
import 'configs/injector/injector_conf.dart';
import 'core/constants/list_translation_locale.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/global_keys.dart';
import 'routes/app_route_path.dart';

/// Root widget for the app. Handles initialization and routing.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// State for MyApp. Sets up router and deep link listeners.
class _MyAppState extends State<MyApp> {
  late final GoRouter _router;
  late final DeepLinkService _deepLinkService;

  @override
  void initState() {
    super.initState();
    _router = getIt<AppRouteConf>().router;

    _deepLinkService = getIt<DeepLinkService>();
    _deepLinkService.initListener((uri) {
      debugPrint("🔗 Received DeepLink URI: $uri");
      _handleDeepLink(uri);
    });
    _deepLinkService.checkInitialUri((uri) {
      debugPrint("🔗 Initial DeepLink URI: $uri");
      _handleDeepLink(uri);
    });
  }

  /// Handles incoming deep links from external apps (e.g. Gmail email clicks)
  void _handleDeepLink(Uri uri) {
    debugPrint("🔗 Processing DeepLink URI: $uri (host: ${uri.host}, path: ${uri.path})");

    switch (uri.host) {
      case "reset-password":
        _navigateToResetPassword(uri);
        break;

      default:
        // Also check if path contains 'reset-password' in case the incoming URI is an HTTP/HTTPS link (e.g., https://<domain>/reset-password?token=...)
        if (uri.path.contains("reset-password") ||
            uri.pathSegments.contains("reset-password")) {
          _navigateToResetPassword(uri);
        } else {
          debugPrint("⚠️ Unhandled deep link host: ${uri.host}");
        }
        break;
    }
  }

  /// Navigates to reset password screen with token and company_code parameters
  void _navigateToResetPassword(Uri uri) {
    final token = uri.queryParameters['token'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _router.goNamed(
          AppRoute.resetPassword.name,
          queryParameters: {
            'token': token ?? '',
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  /// Builds the main app widget tree with theming, localization, and routing.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<ThemeBloc>()),
            BlocProvider(create: (_) => getIt<TranslateBloc>()),
          ],
          child: BlocListener<TranslateBloc, TranslateState>(
            listener: (ctx, translateState) {
              final newLocale = translateState.isMarathi
                  ? marathiLocale
                  : englishLocale;
              ctx.setLocale(newLocale);
            },
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (_, state) {
                return MaterialApp.router(
                  scaffoldMessengerKey: scaffoldMessengerKey,
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    ...context.localizationDelegates,
                  ],
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: ThemeMode.light,
                  routerConfig: _router,
                  builder: (context, child) {
                    final mediaQuery = MediaQuery.of(context);

                    return MediaQuery(
                      data: mediaQuery.copyWith(
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      child: child!,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
