import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_route_path.dart';
import '../../widgets/main_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({
    super.key,
    required this.child,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoute.analytics.path)) return 1;
    if (location.startsWith(AppRoute.customers.path)) return 2;
    if (location.startsWith(AppRoute.requests.path)) return 3;
    if (location.startsWith(AppRoute.settings.path)) return 4;
    if (location.startsWith(AppRoute.home.path)) return 0;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoute.home.path);
        break;
      case 1:
        context.go(AppRoute.analytics.path);
        break;
      case 2:
        context.go(AppRoute.customers.path);
        break;
      case 3:
        context.go(AppRoute.requests.path);
        break;
      case 4:
        context.go(AppRoute.settings.path);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);
    final bool isHome = selectedIndex == 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        if (!isHome) {
          context.go(AppRoute.home.path);
        } else {
          SystemNavigator.pop();
        }
      },
      child: MediaQuery.removeViewInsets(
        removeBottom: true,
        context: context,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColor.pureWhite,
          body: widget.child,
          bottomNavigationBar: MainBottomNavBar(
            currentIndex: selectedIndex,
            onTap: (index) => _onItemTapped(index, context),
          ),
        ),
      ),
    );
  }
}
