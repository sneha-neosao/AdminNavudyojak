import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/theme/app_color.dart';
import '../../../login/bloc/auth_login_bloc/auth_login_bloc.dart';
import '../../widgets/settings_content_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthLoginBloc>(
          create: (_) => getIt<AuthLoginBloc>(),
        ),
      ],
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.pureWhite,
        body: SafeArea(
          bottom: false,
          child: SettingsContentWidget(),
        ),
      ),
    );
  }
}
