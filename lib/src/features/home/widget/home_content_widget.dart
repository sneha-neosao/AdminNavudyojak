import 'package:admin_navudyojak/src/features/home/widget/home_top_bar_widget.dart';
import 'package:admin_navudyojak/src/features/home/widget/return_settlement_card_widget.dart';
import 'package:flutter/material.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import 'cockpit_card_widget.dart';
import 'home_metrics_grid_widget.dart';
import 'new_customers_card_widget.dart';
import 'weekly_movement_card_widget.dart';

class HomeContentWidget extends StatelessWidget {
  const HomeContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.hS,
          const HomeTopBarWidget(),
          16.hS,
          const CockpitCardWidget(),
          16.hS,
          const HomeMetricsGridWidget(),
          16.hS,
          const WeeklyMovementCardWidget(),
          16.hS,
          const ReturnSettlementCardWidget(),
          16.hS,
          const NewCustomersCardWidget(),
          24.hS,
        ],
      ),
    );
  }
}
