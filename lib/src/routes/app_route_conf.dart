import 'package:admin_navudyojak/src/features/customers/widget/customer_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/analytics/presentation/pages/analytics_page.dart';
import '../features/customers/presentation/pages/customer_onboarding_details_screen.dart';
import '../features/customers/presentation/pages/customers_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/login/presentation/pages/login_screen.dart';
import '../features/main_screen/presentation/pages/main_screen.dart';
import '../features/notifications/presentation/pages/notifications_screen.dart';
import '../features/request/presentation/pages/request_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/splash/presentation/pages/splash_screen.dart';
import 'app_route_path.dart';

final GlobalKey<NavigatorState> globalNavigator = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    navigatorKey: globalNavigator,
    initialLocation: AppRoute.splash.path,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        pageBuilder: (context, state) => _fadePage(const SplashScreen()),
      ),
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        pageBuilder: (context, state) => _fadePage(const LoginScreen()),
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => AppRoute.home.path,
      ),
      GoRoute(
        path: AppRoute.mainScreen.path,
        name: AppRoute.mainScreen.name,
        redirect: (context, state) => AppRoute.home.path,
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.home.path,
            name: AppRoute.home.name,
            pageBuilder: (context, state) => _fadePage(const HomeScreen()),
          ),
          GoRoute(
            path: AppRoute.analytics.path,
            name: AppRoute.analytics.name,
            pageBuilder: (context, state) => _fadePage(const AnalyticsScreen()),
          ),
          GoRoute(
            path: AppRoute.customers.path,
            name: AppRoute.customers.name,
            pageBuilder: (context, state) => _fadePage(const CustomersScreen()),
          ),
          GoRoute(
            path: AppRoute.requests.path,
            name: AppRoute.requests.name,
            pageBuilder: (context, state) => _fadePage(const RequestsScreen()),
          ),
          GoRoute(
            path: AppRoute.settings.path,
            name: AppRoute.settings.name,
            pageBuilder: (context, state) => _fadePage(const SettingsScreen()),
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.customerOnboardingDetails.path,
        name: AppRoute.customerOnboardingDetails.name,
        pageBuilder: (context, state) {
          final customer = state.extra as CustomerDetailItem?;
          return _fadePage(
            CustomerOnboardingDetailsScreen(customer: customer),
          );
        },
      ),
      GoRoute(
        path: AppRoute.notifications.path,
        name: AppRoute.notifications.name,
        pageBuilder: (context, state) => _fadePage(
          const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.maintenance.path,
        name: AppRoute.maintenance.name,
        pageBuilder: (context, state) => _fadePage(
          const Scaffold(
            body: Center(
              child: Text(
                'Under Maintenance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

/// Fade page transition conforming strictly to Rule 2
CustomTransitionPage _fadePage(Widget child, {LocalKey? key}) =>
    CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
