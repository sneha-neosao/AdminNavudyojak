import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../../remote/models/analytics_model/business_performance_response.dart';
import '../../widgets/app_snackbar_widget.dart';

class AnalyticsMetricData {
  final String value;
  final String label;
  final String subtext;
  final Color subtextColor;
  final IconData icon;

  const AnalyticsMetricData({
    required this.value,
    required this.label,
    required this.subtext,
    this.subtextColor = AppColor.metricGreen,
    required this.icon,
  });
}

class AnalyticsMetricsRowWidget extends StatelessWidget {
  final SummaryCardsData? summaryCards;
  final bool isLoading;

  const AnalyticsMetricsRowWidget({
    super.key,
    this.summaryCards,
    this.isLoading = false,
  });

  List<AnalyticsMetricData> _buildMetrics() {
    if (summaryCards != null) {
      final rev = summaryCards!.revenue;
      final ord = summaryCards!.ordersFulfilled;
      final cust = summaryCards!.activeCustomers;

      return [
        AnalyticsMetricData(
          value: rev?.formatValue(isCurrency: true) ?? '₹0',
          label: rev?.title.isNotEmpty == true ? rev!.title : 'Revenue',
          subtext: rev?.trendText ?? '↗ +0%',
          subtextColor: rev?.isPositiveTrend == false
              ? AppColor.pendingBadgeRed
              : AppColor.metricGreen,
          icon: Icons.currency_rupee_rounded,
        ),
        AnalyticsMetricData(
          value: ord?.formatValue() ?? '0',
          label: ord?.title.isNotEmpty == true
              ? ord!.title
              : 'Orders fulfilled',
          subtext: ord?.trendText ?? '↗ +0%',
          subtextColor: ord?.isPositiveTrend == false
              ? AppColor.pendingBadgeRed
              : AppColor.metricGreen,
          icon: Icons.inventory_2_outlined,
        ),
        AnalyticsMetricData(
          value: cust?.formatValue() ?? '0',
          label: cust?.title.isNotEmpty == true
              ? cust!.title
              : 'Active customers',
          subtext: cust?.trendText ?? '↗ +0%',
          subtextColor: cust?.isPositiveTrend == false
              ? AppColor.pendingBadgeRed
              : AppColor.metricGreen,
          icon: Icons.people_outline_rounded,
        ),
      ];
    }

    // Default placeholder metrics during initial loading or fallback
    return const [
      AnalyticsMetricData(
        value: '₹28.4L',
        label: 'Revenue',
        subtext: '↗ +18.4%',
        subtextColor: AppColor.metricGreen,
        icon: Icons.currency_rupee_rounded,
      ),
      AnalyticsMetricData(
        value: '186',
        label: 'Orders fulfilled',
        subtext: '↗ +9.2%',
        subtextColor: AppColor.metricGreen,
        icon: Icons.inventory_2_outlined,
      ),
      AnalyticsMetricData(
        value: '1,248',
        label: 'Active customers',
        subtext: '↗ +6.8%',
        subtextColor: AppColor.metricGreen,
        icon: Icons.people_outline_rounded,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _buildMetrics();

    return Skeletonizer(
      enabled: isLoading,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildMetricCard(context, metrics[0])),
              10.wS,
              Expanded(child: _buildMetricCard(context, metrics[1])),
              10.wS,
              Expanded(child: _buildMetricCard(context, metrics[2])),
            ],
          ),
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
        onTap: isLoading
            ? null
            : () {
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
              Skeleton.ignore(
                child: Icon(
                  item.icon,
                  size: 20.sp,
                  color: AppColor.cockpitOrange,
                ),
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
                  color: item.subtextColor,
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
