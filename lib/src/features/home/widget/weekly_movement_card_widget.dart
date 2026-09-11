import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

class WeeklyMovementCardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String salesValue;
  final String productionValue;
  final String expensesValue;

  const WeeklyMovementCardWidget({
    super.key,
    this.title = 'Weekly business movement',
    this.subtitle = 'Sales, purchases, expenses and production value',
    this.salesValue = '₹4.82L',
    this.productionValue = '1,842',
    this.expensesValue = '₹68.4K',
  });

  @override
  State<WeeklyMovementCardWidget> createState() => _WeeklyMovementCardWidgetState();
}

class _WeeklyMovementCardWidgetState extends State<WeeklyMovementCardWidget> {
  String _selectedFilter = 'This week';
  final List<String> _filterOptions = const [
    'This week',
    'Last week',
    'This month',
  ];

  static const List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColor.metricCardBorder,
          width: 1.2,
        ),
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
            initialValue: _selectedFilter,
            onSelected: (val) {
              setState(() {
                _selectedFilter = val;
              });
            },
            itemBuilder: (context) => _filterOptions
                .map(
                  (item) => PopupMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: item == _selectedFilter
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: item == _selectedFilter
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
                    _selectedFilter,
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

          // Chart canvas area (blank chart area)
          110.hS,

          // Days Axis (M T W T F S S)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _days.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.slateGrey,
                    ),
                    softWrap: true,
                  ),
                ),
              );
            }).toList(),
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
