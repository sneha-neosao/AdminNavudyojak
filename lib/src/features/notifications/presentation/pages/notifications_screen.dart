import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/theme/app_color.dart';
import '../../bloc/mark_all_notifications_read_bloc/mark_all_notifications_read_bloc.dart';
import '../../bloc/mark_notification_read_bloc/mark_notification_read_bloc.dart';
import '../../bloc/notifications_bloc/notifications_bloc.dart';
import '../../widgets/notifications_content_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationsBloc>(
          create: (_) => getIt<NotificationsBloc>()
            ..add(const GetNotificationsEvent(status: 'all')),
        ),
        BlocProvider<MarkAllNotificationsReadBloc>(
          create: (_) => getIt<MarkAllNotificationsReadBloc>(),
        ),
        BlocProvider<MarkNotificationReadBloc>(
          create: (_) => getIt<MarkNotificationReadBloc>(),
        ),
      ],
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.pureWhite,
        body: SafeArea(
          bottom: false,
          child: NotificationsContentWidget(),
        ),
      ),
    );
  }
}
