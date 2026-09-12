import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../../remote/models/analytics_model/business_performance_response.dart';

class RevenueMarginCardWidget extends StatelessWidget {
  final RevenueAndMarginData? data;
  final bool isLoading;
  final VoidCallback? onTap;

  const RevenueMarginCardWidget({
    super.key,
    this.data,
    this.isLoading = false,
    this.onTap,
  });

  static const List<String> _defaultMonthNames = [
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = data?.title.isNotEmpty == true
        ? data!.title
        : 'Revenue and margin';
    final subtitle = data?.subtitle.isNotEmpty == true
        ? data!.subtitle
        : 'Track growth without losing profitability.';
    final grossMargin = data != null ? data!.formattedGrossMargin : '24.8%';
    final statusBadge = data != null
        ? data!.formattedStatusBadge
        : '1.4% below target';
    final isBelowTarget = data?.isBelowTarget ?? true;

    final monthlyData = data?.monthlyData ?? [];
    final maxRevenue = monthlyData.fold<num>(
      0,
      (maxVal, item) => max(maxVal, item.revenue),
    );

    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
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
        child: Material(
          color: AppColor.transparent,
          borderRadius: BorderRadius.circular(22.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(22.r),
            onTap: isLoading ? null : onTap,
            splashColor: AppColor.orangeTint2.withValues(alpha: 0.5),
            highlightColor: AppColor.orangeTint2.withValues(alpha: 0.3),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
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
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textSecondary,
                    ),
                    softWrap: true,
                  ),
                  20.hS,

                  // Chart Area
                  SizedBox(
                    height: 140.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(12, (index) {
                        final monthNum = index + 1;
                        final point = monthlyData.firstWhere(
                          (p) => p.month == monthNum,
                          orElse: () => MonthlyDataPoint(
                            month: monthNum,
                            monthName: _defaultMonthNames[index],
                          ),
                        );

                        final hasData = point.revenue > 0;
                        final barRatio = maxRevenue > 0
                            ? (point.revenue / maxRevenue).clamp(0.15, 1.0)
                            : 0.0;
                        final barHeight = (100.h * barRatio).clamp(8.h, 100.h);

                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (hasData)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                      vertical: 2.h,
                                    ),
                                    margin: EdgeInsets.only(bottom: 4.h),
                                    decoration: BoxDecoration(
                                      color: AppColor.cockpitOrange,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      '${point.marginPercentage.toInt()}%',
                                      style: TextStyle(
                                        color: AppColor.pureWhite,
                                        fontSize: 8.5.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                Container(
                                  height: hasData ? barHeight : 6.h,
                                  decoration: BoxDecoration(
                                    color: hasData
                                        ? AppColor.cockpitOrange
                                        : AppColor.metricCardBorder.withValues(
                                            alpha: 0.7,
                                          ),
                                    borderRadius: BorderRadius.circular(4.r),
                                    gradient: hasData
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

                  // Month Names Axis Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(12, (index) {
                      final monthNum = index + 1;
                      final point = monthlyData.firstWhere(
                        (p) => p.month == monthNum,
                        orElse: () => MonthlyDataPoint(
                          month: monthNum,
                          monthName: _defaultMonthNames[index],
                        ),
                      );

                      final name = point.monthName.isNotEmpty
                          ? point.monthName
                          : _defaultMonthNames[index];

                      return Expanded(
                        child: Center(
                          child: Text(
                            name,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.slateGrey,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }),
                  ),
                  10.hS,

                  // Divider Line
                  Divider(
                    color: AppColor.metricCardBorder.withValues(alpha: 0.8),
                    height: 1,
                    thickness: 1,
                  ),
                  14.hS,

                  // Bottom Row: Gross margin and Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Gross margin ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.black,
                              ),
                            ),
                            TextSpan(
                              text: grossMargin,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Badge: below or above target
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: isBelowTarget
                              ? AppColor.pendingBadgeRed
                              : AppColor.customerBadgeGreen,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          statusBadge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5.sp,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
