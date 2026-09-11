import 'package:admin_navudyojak/src/features/home/widget/home_metric_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import 'home_metric_item.dart';

class HomeMetricsGridWidget extends StatelessWidget {
  final List<HomeMetricItem> items;
  final ValueChanged<HomeMetricItem>? onMetricTap;

  const HomeMetricsGridWidget({
    super.key,
    this.items = defaultMetrics,
    this.onMetricTap,
  });

  static const List<HomeMetricItem> defaultMetrics = [
    HomeMetricItem(
      value: '₹4.82L',
      label: 'Sales',
      subtext: '+12.4%',
      icon: Icons.currency_rupee_rounded,
    ),
    HomeMetricItem(
      value: '₹2.16L',
      label: 'Purchases',
      subtext: '18 bills',
      icon: Icons.receipt_long_outlined,
    ),
    HomeMetricItem(
      value: '₹9.4L',
      label: 'Raw material',
      subtext: '82% available',
      icon: Icons.category_outlined,
    ),
    HomeMetricItem(
      value: '1,842',
      label: 'Finished products',
      subtext: 'units ready',
      icon: Icons.inventory_2_outlined,
    ),
    HomeMetricItem(
      value: '1,248',
      label: 'Customers',
      subtext: '+24 this week',
      icon: Icons.people_outline_rounded,
    ),
    HomeMetricItem(
      value: '₹68,400',
      label: 'Expenses',
      subtext: '8.2% of sales',
      icon: Icons.factory_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (items.length < 6) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: HomeMetricCardWidget(
                    item: items[0],
                    onTap: () => onMetricTap?.call(items[0]),
                  ),
                ),
                10.wS,
                Expanded(
                  child: HomeMetricCardWidget(
                    item: items[1],
                    onTap: () => onMetricTap?.call(items[1]),
                  ),
                ),
                10.wS,
                Expanded(
                  child: HomeMetricCardWidget(
                    item: items[2],
                    onTap: () => onMetricTap?.call(items[2]),
                  ),
                ),
              ],
            ),
          ),
          10.hS,
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: HomeMetricCardWidget(
                    item: items[3],
                    onTap: () => onMetricTap?.call(items[3]),
                  ),
                ),
                10.wS,
                Expanded(
                  child: HomeMetricCardWidget(
                    item: items[4],
                    onTap: () => onMetricTap?.call(items[4]),
                  ),
                ),
                10.wS,
                Expanded(
                  child: HomeMetricCardWidget(
                    item: items[5],
                    onTap: () => onMetricTap?.call(items[5]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
