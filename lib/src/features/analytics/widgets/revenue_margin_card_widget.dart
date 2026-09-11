import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';

class RevenueMarginCardWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const RevenueMarginCardWidget({
    super.key,
    this.onTap,
  });

  static const List<String> _monthNumbers = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
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
      child: Material(
        color: AppColor.transparent,
        borderRadius: BorderRadius.circular(22.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(22.r),
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else {
              AppSnackBarWidget.show(
                context,
                message: 'Revenue & Margin chart selected',
                type: ToastType.info,
              );
            }
          },
          splashColor: AppColor.orangeTint2.withValues(alpha: 0.5),
          highlightColor: AppColor.orangeTint2.withValues(alpha: 0.3),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Revenue and margin',
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
                  'Track growth without losing profitability.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.textSecondary,
                  ),
                  softWrap: true,
                ),
                20.hS,

                // Open Chart canvas area
                150.hS,

                // 1 to 12 Numbers Axis Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _monthNumbers.map((month) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          month,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.slateGrey,
                          ),
                          softWrap: true,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                10.hS,

                // Divider Line
                Divider(
                  color: AppColor.metricCardBorder.withValues(alpha: 0.8),
                  height: 1,
                  thickness: 1,
                ),
                14.hS,

                // Bottom Row: Gross margin 24.8% and Badge
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
                            text: '24.8%',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColor.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Red Badge: 1.4% below target
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.pendingBadgeRed,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '1.4% below target',
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
    );
  }
}
