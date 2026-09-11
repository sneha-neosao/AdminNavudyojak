import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/theme/app_color.dart';
import '../../bloc/business_performance_bloc/business_performance_bloc.dart';
import '../../widgets/analytics_content_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BusinessPerformanceBloc>(
          create: (_) => getIt<BusinessPerformanceBloc>()
            ..add(const GetBusinessPerformanceEvent()),
        ),
      ],
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.pureWhite,
        body: SafeArea(
          bottom: false,
          child: AnalyticsContentWidget(),
        ),
      ),
    );
  }
}
