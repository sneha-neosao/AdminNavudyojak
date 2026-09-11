import 'package:admin_navudyojak/src/features/analytics/widgets/analytics_header_widget.dart';
import 'package:admin_navudyojak/src/features/analytics/widgets/analytics_metrics_row_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import 'owner_scorecard_card_widget.dart';
import 'revenue_margin_card_widget.dart';

class AnalyticsContentWidget extends StatelessWidget {
  const AnalyticsContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.hS,
          const AnalyticsHeaderWidget(),
          16.hS,
          const AnalyticsMetricsRowWidget(),
          16.hS,
          const RevenueMarginCardWidget(),
          16.hS,
          const OwnerScorecardCardWidget(),
          24.hS,
        ],
      ),
    );
  }
}
