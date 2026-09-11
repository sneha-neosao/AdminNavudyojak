import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../../remote/models/dashboard_model/admin_dashboard_response.dart';

class WeeklyMovementCardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String salesValue;
  final String productionValue;
  final String expensesValue;
  final List<DailyBreakdownItem>? dailyBreakdown;
  final String currentPeriod;
  final ValueChanged<String>? onPeriodChanged;
  final bool isLoading;

  const WeeklyMovementCardWidget({
    super.key,
    this.title = 'Weekly business movement',
    this.subtitle = 'Sales, purchases, expenses and production value',
    this.salesValue = '₹4.82L',
    this.productionValue = '1,842',
    this.expensesValue = '₹68.4K',
    this.dailyBreakdown,
    this.currentPeriod = 'this_week',
    this.onPeriodChanged,
    this.isLoading = false,
  });

  @override
  State<WeeklyMovementCardWidget> createState() =>
      _WeeklyMovementCardWidgetState();
}

class _WeeklyMovementCardWidgetState extends State<WeeklyMovementCardWidget> {
  static const List<String> _filterOptions = [
    'This week',
    'This month',
    'This year',
  ];

  static const Map<String, String> _periodToLabel = {
    'this_week': 'This week',
    'this_month': 'This month',
    'this_year': 'This year',
  };

  static const Map<String, String> _labelToPeriod = {
    'This week': 'this_week',
    'This month': 'this_month',
    'This year': 'this_year',
  };

  static const List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedLabel = _periodToLabel[widget.currentPeriod] ?? 'This week';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColor.metricCardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
              letterSpacing: -0.2,
            ),
            softWrap: true,
          ),
          4.hS,

          // Subtitle
          Text(
            widget.subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
            ),
            softWrap: true,
          ),
          14.hS,

          // Filter Dropdown Button
          PopupMenuButton<String>(
            color: AppColor.card,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: const BorderSide(color: AppColor.metricCardBorder),
            ),
            initialValue: selectedLabel,
            onSelected: (label) {
              final periodCode = _labelToPeriod[label] ?? 'this_week';
              if (periodCode != widget.currentPeriod) {
                widget.onPeriodChanged?.call(periodCode);
              }
            },
            itemBuilder: (context) => _filterOptions
                .map(
                  (item) => PopupMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: item == selectedLabel
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: item == selectedLabel
                            ? AppColor.primary
                            : AppColor.charcoal,
                      ),
                      softWrap: true,
                    ),
                  ),
                )
                .toList(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColor.card,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColor.metricCardBorder,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.black,
                    ),
                    softWrap: true,
                  ),
                  8.wS,
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18.sp,
                    color: AppColor.black,
                  ),
                ],
              ),
            ),
          ),
          20.hS,

          // Content area wrapped in Skeletonizer for per-card loading on period change
          Skeletonizer(
            enabled: widget.isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chart canvas area with daily breakdown bars
                SizedBox(
                  height: 100.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      DailyBreakdownItem? item;
                      if (widget.dailyBreakdown != null &&
                          index < widget.dailyBreakdown!.length) {
                        item = widget.dailyBreakdown![index];
                      }

                      final salesVal = item?.sales ?? 0;
                      final num maxSales = (widget.dailyBreakdown ?? [])
                          .map((e) => e.sales ?? 0)
                          .fold<num>(
                            0,
                            (prev, elem) => elem > prev ? elem : prev,
                          );

                      final double barRatio = maxSales > 0
                          ? (salesVal / maxSales).clamp(0.12, 1.0)
                          : 0.12;
                      final bool hasSales = salesVal > 0;

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 76.h * barRatio,
                                decoration: BoxDecoration(
                                  color: hasSales
                                      ? AppColor.cockpitOrange
                                      : AppColor.metricCardBorder.withValues(
                                          alpha: 0.7,
                                        ),
                                  borderRadius: BorderRadius.circular(6.r),
                                  gradient: hasSales
                                      ? const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            AppColor.cockpitOrange,
                                            AppColor.primary,
                                          ],
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                10.hS,

                // Days Axis (M T W T F S S)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    String dayText = _days[index];
                    if (widget.dailyBreakdown != null &&
                        index < widget.dailyBreakdown!.length) {
                      dayText =
                          widget.dailyBreakdown![index].dayShort ?? dayText;
                    }

                    return Expanded(
                      child: Center(
                        child: Text(
                          dayText,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.slateGrey,
                          ),
                          softWrap: true,
                        ),
                      ),
                    );
                  }),
                ),
                12.hS,

                // Divider Line
                Divider(
                  color: AppColor.metricCardBorder.withValues(alpha: 0.8),
                  height: 1,
                  thickness: 1,
                ),
                14.hS,

                // Bottom 3 Metrics Row
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricItem(
                        context,
                        label: 'Sales',
                        value: widget.salesValue,
                      ),
                    ),
                    12.wS,
                    Expanded(
                      child: _buildMetricItem(
                        context,
                        label: 'Production',
                        value: widget.productionValue,
                      ),
                    ),
                    12.wS,
                    Expanded(
                      child: _buildMetricItem(
                        context,
                        label: 'Expenses',
                        value: widget.expensesValue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.textSecondary,
          ),
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        4.hS,
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColor.black,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
