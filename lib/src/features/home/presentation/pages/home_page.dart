import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../remote/models/app_version_model/app_version_response.dart';
import '../../../app_version/bloc/app_version_bloc/app_version_bloc.dart';
import '../../../app_version/widgets/app_update_dialog.dart';
import '../../../app_version/widgets/maintenance_mode_dialog.dart';
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
  bool _isMaintenanceDialogOpen = false;
  bool _isUpdateDialogOpen = false;
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
            if (data != null) {
              if (data.isMaintenanceMode) {
                if (mounted && !_isMaintenanceDialogOpen) {
                  _isMaintenanceDialogOpen = true;
                  MaintenanceModeDialog.show(
                    context: context,
                    message: data.maintenanceMessage,
                  );
                }
              } else {
                _checkAppUpdate(data);
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

  Future<void> _checkAppUpdate(AppVersionData data) async {
    if (_isUpdateDialogOpen || !mounted) return;

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final actualVersion = packageInfo.version.trim();
      final apiCurrentVersion = data.currentVersion.trim();
      final apiMinRequired = data.minRequiredVersion.trim();

      final cleanActual = actualVersion.split('+').first.trim();
      final cleanApiCurrent = apiCurrentVersion.split('+').first.trim();
      final cleanApiMinRequired = apiMinRequired.split('+').first.trim();

      if (cleanApiCurrent.isNotEmpty && cleanActual != cleanApiCurrent) {
        _isUpdateDialogOpen = true;
        // If current_version and min_required_version are same -> don't show cancel button (mandatory)
        // If they are different -> show cancel button (optional)
        final bool showCancelButton = cleanApiCurrent != cleanApiMinRequired;

        if (mounted) {
          AppUpdateDialog.show(
            context: context,
            currentVersion: apiCurrentVersion,
            updateUrl: data.updateUrl,
            showCancelButton: showCancelButton,
          );
        }
      }
    } catch (e) {
      logger.e('Error checking app update: $e');
    }
  }
}
