import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_route_path.dart';
import '../../../app_version/bloc/app_version_bloc/app_version_bloc.dart';
import '../../../profile/bloc/profile_details_bloc/profile_details_bloc.dart';
import '../../../notifications/bloc/notifications_count_bloc/notifications_count_bloc.dart';
import '../../widget/home_content_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AppVersionBloc _appVersionBloc;
  late final ProfileDetailsBloc _profileDetailsBloc;
  late final NotificationsCountBloc _notificationsCountBloc;

  @override
  void initState() {
    super.initState();
    _appVersionBloc = getIt<AppVersionBloc>();
    _appVersionBloc.add(const CheckAppVersionEvent(appName: 'admin_app'));

    _profileDetailsBloc = getIt<ProfileDetailsBloc>();
    _profileDetailsBloc.add(const GetProfileDetailsEvent());

    _notificationsCountBloc = getIt<NotificationsCountBloc>();
    _notificationsCountBloc.add(const GetNotificationsCountEvent());
  }

  @override
  void dispose() {
    _notificationsCountBloc.close();
    _profileDetailsBloc.close();
    _appVersionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppVersionBloc>.value(
          value: _appVersionBloc,
        ),
        BlocProvider<ProfileDetailsBloc>.value(
          value: _profileDetailsBloc,
        ),
        BlocProvider<NotificationsCountBloc>.value(
          value: _notificationsCountBloc,
        ),
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
          body: SafeArea(
            child: HomeContentWidget(),
          ),
        ),
      ),
    );
  }
}
