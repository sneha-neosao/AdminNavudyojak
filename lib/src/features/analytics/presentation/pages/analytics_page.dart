import 'package:admin_navudyojak/src/features/analytics/widgets/analytics_content_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.pureWhite,
      body: SafeArea(
        bottom: false,
        child: AnalyticsContentWidget(),
      ),
    );
  }
}
