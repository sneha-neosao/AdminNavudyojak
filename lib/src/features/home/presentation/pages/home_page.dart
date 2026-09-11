import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_route_path.dart';
import '../../../app_version/bloc/app_version_bloc/app_version_bloc.dart';
import '../../../profile/bloc/update_fcm_token_bloc/update_fcm_token_bloc.dart';
import '../../../notifications/bloc/notifications_count_bloc/notifications_count_bloc.dart';
import '../../bloc/admin_dashboard_bloc/admin_dashboard_bloc.dart';
import '../../widget/home_content_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppVersionBloc _appVersionBloc;
  late final NotificationsCountBloc _notificationsCountBloc;
  late final UpdateFcmTokenBloc _updateFcmTokenBloc;
  late final AdminDashboardBloc _adminDashboardBloc;

  @override
  void initState() {
    super.initState();
    _adminDashboardBloc = getIt<AdminDashboardBloc>();
    _adminDashboardBloc.add(const GetAdminDashboardEvent());

    _updateFcmTokenBloc = getIt<UpdateFcmTokenBloc>();
    _fetchAndPrintFcmToken();

    _appVersionBloc = getIt<AppVersionBloc>();
    _appVersionBloc.add(const CheckAppVersionEvent(appName: 'admin_app'));

    _notificationsCountBloc = getIt<NotificationsCountBloc>();
    _notificationsCountBloc.add(const GetNotificationsCountEvent());
  }

  Future<void> _fetchAndPrintFcmToken() async {
    await NotificationService.requestNotificationPermission();
    final token = await NotificationService.getToken();
    debugPrint('================ FCM TOKEN ================');
    debugPrint('$token');
    debugPrint('===========================================');
    logger.i('FCM Token: $token');
    if (token != null && token.isNotEmpty) {
      _updateFcmTokenBloc.add(SubmitUpdateFcmTokenEvent(token));
    }
  }

  @override
  void dispose() {
    _adminDashboardBloc.close();
    _updateFcmTokenBloc.close();
    _notificationsCountBloc.close();
    _appVersionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminDashboardBloc>.value(value: _adminDashboardBloc),
        BlocProvider<AppVersionBloc>.value(value: _appVersionBloc),
        BlocProvider<NotificationsCountBloc>.value(
          value: _notificationsCountBloc,
        ),
        BlocProvider<UpdateFcmTokenBloc>.value(value: _updateFcmTokenBloc),
      ],
      child: BlocListener<AppVersionBloc, AppVersionState>(
        listener: (context, state) {
          if (state is AppVersionSuccessState) {
            final data = state.data.data;
            if (data != null && data.isMaintenanceMode) {
              if (mounted) {
                context.go(AppRoute.maintenance.path);
              }
            }
          }
        },
        child: const Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColor.pureWhite,
          body: SafeArea(child: HomeContentWidget()),
        ),
      ),
    );
  }
}
