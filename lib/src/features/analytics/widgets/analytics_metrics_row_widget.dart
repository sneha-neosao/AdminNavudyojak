import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';

class AnalyticsMetricData {
  final String value;
  final String label;
  final String subtext;
  final IconData icon;

  const AnalyticsMetricData({
    required this.value,
    required this.label,
    required this.subtext,
    required this.icon,
  });
}

class AnalyticsMetricsRowWidget extends StatelessWidget {
  const AnalyticsMetricsRowWidget({super.key});

  static const List<AnalyticsMetricData> _metrics = [
    AnalyticsMetricData(
      value: '₹28.4L',
      label: 'Revenue',
      subtext: '↗ +18.4%',
      icon: Icons.currency_rupee_rounded,
    ),
    AnalyticsMetricData(
      value: '186',
      label: 'Orders fulfilled',
      subtext: '↗ +9.2%',
      icon: Icons.inventory_2_outlined,
    ),
    AnalyticsMetricData(
      value: '1,248',
      label: 'Active customers',
      subtext: '↗ +6.8%',
      icon: Icons.people_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildMetricCard(context, _metrics[0])),
            10.wS,
            Expanded(child: _buildMetricCard(context, _metrics[1])),
            10.wS,
            Expanded(child: _buildMetricCard(context, _metrics[2])),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, AnalyticsMetricData item) {
    final theme = Theme.of(context);

    return Material(
      color: AppColor.card,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () {
          AppSnackBarWidget.show(
            context,
            message: '${item.label}: ${item.value} selected',
            type: ToastType.info,
          );
        },
        splashColor: AppColor.orangeTint2.withValues(alpha: 0.5),
        highlightColor: AppColor.orangeTint2.withValues(alpha: 0.3),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColor.metricCardBorder,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 20.sp,
                color: AppColor.cockpitOrange,
              ),
              8.hS,
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  item.value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.black,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  softWrap: true,
                ),
              ),
              3.hS,
              Text(
                item.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textSecondary,
                ),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              6.hS,
              Text(
                item.subtext,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.metricGreen,
                ),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
