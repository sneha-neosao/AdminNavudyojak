import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../../remote/models/analytics_model/business_performance_response.dart';

class OwnerScorecardCardWidget extends StatelessWidget {
  final List<OwnerScorecardItem>? items;
  final bool isLoading;
  final ValueChanged<OwnerScorecardItem>? onItemTap;

  const OwnerScorecardCardWidget({
    super.key,
    this.items,
    this.isLoading = false,
    this.onItemTap,
  });

  static const List<OwnerScorecardItem> _defaultItems = [
    OwnerScorecardItem(
      id: 'collections_efficiency',
      title: 'Collections efficiency',
      value: 82,
      status: 'Healthy',
      statusVariant: 'success',
    ),
    OwnerScorecardItem(
      id: 'on_time_fulfilment',
      title: 'On-time fulfilment',
      value: 91,
      status: 'Healthy',
      statusVariant: 'success',
    ),
    OwnerScorecardItem(
      id: 'buyback_approval_rate',
      title: 'Buyback approval rate',
      value: 68,
      status: 'Watch',
      statusVariant: 'warning',
    ),
    OwnerScorecardItem(
      id: 'low_stock_exposure',
      title: 'Low-stock exposure',
      value: 0,
      status: 'Healthy',
      statusVariant: 'success',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayItems = (items != null && items!.isNotEmpty)
        ? items!
        : _defaultItems;

    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
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
            // Header Row with Icon & Title
            Row(
              children: [
                Skeleton.ignore(
                  child: Icon(
                    Icons.bar_chart_rounded,
                    size: 22.sp,
                    color: AppColor.cockpitOrange,
                  ),
                ),
                8.wS,
                Text(
                  'Owner scorecard',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.black,
                    letterSpacing: -0.2,
                  ),
                  softWrap: true,
                ),
              ],
            ),
            12.hS,

            // Scorecard Items
            ...List.generate(displayItems.length, (index) {
              final item = displayItems[index];
              return Column(
                children: [
                  if (index > 0)
                    Divider(
                      color: AppColor.metricCardBorder.withValues(alpha: 0.8),
                      height: 1,
                      thickness: 1,
                    ),
                  Material(
                    color: AppColor.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.r),
                      onTap: isLoading || onItemTap == null
                          ? null
                          : () => onItemTap!(item),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black,
                                ),
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            10.wS,
                            Text(
                              item.displayValue,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColor.black,
                              ),
                              softWrap: true,
                            ),
                            10.wS,
                            _buildBadge(context, item),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, OwnerScorecardItem item) {
    final theme = Theme.of(context);

    Color bgColor;
    Color textColor = AppColor.white;
    Border? border;

    if (item.isSuccess) {
      bgColor = AppColor.customerBadgeGreen;
    } else if (item.isDanger) {
      bgColor = AppColor.pendingBadgeRed;
    } else if (item.isWarning) {
      bgColor = AppColor.cockpitOrange;
    } else {
      bgColor = AppColor.transparent;
      textColor = AppColor.black;
      border = Border.all(color: AppColor.metricCardBorder, width: 1.2);
    }

    return Container(
      constraints: BoxConstraints(minWidth: 62.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
        border: border,
      ),
      child: Center(
        child: Text(
          item.status,
          style: theme.textTheme.labelSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 11.5.sp,
          ),
          softWrap: true,
        ),
      ),
    );
  }
}
