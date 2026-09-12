import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../../remote/models/dashboard_model/admin_dashboard_response.dart';

class WeeklyMovementCardWidget extends StatefulWidget {
  final String? title;
  final String subtitle;
  final String salesValue;
  final String productionValue;
  final String expensesValue;
  final List<DailyBreakdownItem>? dailyBreakdown;
  final String currentPeriod;
  final String? granularity;
  final ValueChanged<String>? onPeriodChanged;
  final bool isLoading;

  const WeeklyMovementCardWidget({
    super.key,
    this.title,
    this.subtitle = 'Sales, purchases, expenses and production value',
    this.salesValue = '₹4.82L',
    this.productionValue = '1,842',
    this.expensesValue = '₹68.4K',
    this.dailyBreakdown,
    this.currentPeriod = 'this_week',
    this.granularity,
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

  late String _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.currentPeriod;
  }

  @override
  void didUpdateWidget(WeeklyMovementCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPeriod != widget.currentPeriod) {
      _selectedPeriod = widget.currentPeriod;
    }
  }

  String get _activePeriod {
    final period = _selectedPeriod.isNotEmpty
        ? _selectedPeriod
        : widget.currentPeriod;
    final lowerPeriod = period.toLowerCase();
    if (lowerPeriod.contains('month') || lowerPeriod.contains('year')) {
      return lowerPeriod;
    }
    final gran = (widget.granularity ?? '').toLowerCase();
    if (gran.contains('month') || gran.contains('year')) {
      return gran;
    }
    return lowerPeriod.isNotEmpty ? lowerPeriod : 'this_week';
  }

  bool get _isYear => _activePeriod.contains('year');
  bool get _isMonth => _activePeriod.contains('month');

  String get _computedTitle {
    if (widget.title != null &&
        widget.title!.isNotEmpty &&
        widget.title != 'Weekly business movement') {
      return widget.title!;
    }
    if (_isYear) {
      return 'Monthly Business Movement — This Year';
    } else if (_isMonth) {
      return 'Weekly Business Movement — This Month';
    } else {
      return 'Daily Business Movement — This Week';
    }
  }

  int get _itemCount {
    if (_isYear) {
      return 12; // Always 12 months for year (Jan - Dec)
    }
    if (_isMonth) {
      if (widget.dailyBreakdown != null && widget.dailyBreakdown!.length == 5) {
        return 5;
      }
      return 4; // Always 4 weeks for month (Week 1 - Week 4)
    }
    return 7; // Always 7 days for week (Mon - Sun)
  }

  DailyBreakdownItem? _getItem(int index) {
    if (widget.dailyBreakdown == null || widget.dailyBreakdown!.isEmpty) {
      return null;
    }

    if (_isYear) {
      if (widget.dailyBreakdown!.length == 12) {
        return widget.dailyBreakdown![index];
      }
      const monthPrefixes = [
        'jan',
        'feb',
        'mar',
        'apr',
        'may',
        'jun',
        'jul',
        'aug',
        'sep',
        'oct',
        'nov',
        'dec',
      ];
      final targetPrefix = monthPrefixes[index];
      final targetNum = index + 1;
      for (final item in widget.dailyBreakdown!) {
        final raw = (item.dayShort ?? item.dayName ?? item.date ?? '')
            .toLowerCase();
        if (raw.startsWith(targetPrefix)) {
          return item;
        }
        final numVal = int.tryParse(raw);
        if (numVal == targetNum) {
          return item;
        }
        if (item.date != null) {
          final monthStr = targetNum < 10 ? '0$targetNum' : '$targetNum';
          if (item.date!.contains('-$monthStr-') ||
              item.date!.endsWith('-$monthStr')) {
            return item;
          }
        }
      }
      if (index < widget.dailyBreakdown!.length) {
        return widget.dailyBreakdown![index];
      }
      return null;
    } else if (_isMonth) {
      if (widget.dailyBreakdown!.length <= 5) {
        if (index < widget.dailyBreakdown!.length) {
          return widget.dailyBreakdown![index];
        }
        return null;
      }
      // If backend returned daily data (e.g. 28-31 days), aggregate weekly
      final start = index * 7;
      final end = index == 3
          ? widget.dailyBreakdown!.length
          : (start + 7).clamp(0, widget.dailyBreakdown!.length);
      if (start >= widget.dailyBreakdown!.length) {
        return null;
      }
      num totalSales = 0;
      num totalPurchases = 0;
      num totalProduction = 0;
      num totalExpenses = 0;
      for (int i = start; i < end; i++) {
        final it = widget.dailyBreakdown![i];
        totalSales += it.sales ?? 0;
        totalPurchases += it.purchases ?? 0;
        totalProduction += it.production ?? 0;
        totalExpenses += it.expenses ?? 0;
      }
      return DailyBreakdownItem(
        dayShort: 'Week ${index + 1}',
        dayName: 'Week ${index + 1}',
        sales: totalSales,
        purchases: totalPurchases,
        production: totalProduction,
        expenses: totalExpenses,
      );
    } else {
      if (index < widget.dailyBreakdown!.length) {
        return widget.dailyBreakdown![index];
      }
      return null;
    }
  }

  String _getBarBottomLabel(int index) {
    if (_isYear) {
      const defaultMonths = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return defaultMonths[index];
    } else if (_isMonth) {
      return 'Week ${index + 1}';
    } else {
      const defaultDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final item = _getItem(index);
      final raw = item?.dayShort ?? item?.dayName;
      if (raw != null && raw.trim().length >= 3) {
        final t = raw.trim();
        return '${t[0].toUpperCase()}${t.substring(1, 3).toLowerCase()}';
      }
      return defaultDays[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedLabel = _periodToLabel[_selectedPeriod] ??
        _periodToLabel[widget.currentPeriod] ??
        'This week';
    final totalItems = _itemCount;

    // Responsive styling according to item count and granularity
    final double barHorizontalPadding = _isYear
        ? 1.5.w
        : (_isMonth ? 8.w : 5.w);
    final double barRadius = _isYear ? 3.r : (_isMonth ? 6.r : 5.r);
    final double labelFontSize = _isYear ? 9.5.sp : 11.5.sp;

    final num maxSales = List.generate(
      totalItems,
      (i) => _getItem(i)?.sales ?? 0,
    ).fold<num>(0, (prev, elem) => elem > prev ? elem : prev);

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
            _computedTitle,
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
              setState(() {
                _selectedPeriod = periodCode;
              });
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
                // Chart canvas area with dynamic breakdown bars
                SizedBox(
                  height: 100.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(totalItems, (index) {
                      final item = _getItem(index);
                      final salesVal = item?.sales ?? 0;

                      final double barRatio = maxSales > 0
                          ? (salesVal / maxSales).clamp(0.12, 1.0)
                          : 0.12;
                      final bool hasSales = salesVal > 0;

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: barHorizontalPadding,
                          ),
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
                                  borderRadius: BorderRadius.circular(
                                    barRadius,
                                  ),
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

                // Granularity Axis (Mon-Sun, Week 1-4, Jan-Dec)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(totalItems, (index) {
                    final labelText = _getBarBottomLabel(index);

                    return Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              labelText,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.w600,
                                color: AppColor.slateGrey,
                              ),
                              softWrap: true,
                              maxLines: 1,
                            ),
                          ),
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
