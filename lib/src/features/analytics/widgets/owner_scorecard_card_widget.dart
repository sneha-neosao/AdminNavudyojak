import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';

enum ScorecardStatus { healthy, watch, action }

class ScorecardItemData {
  final String label;
  final String value;
  final String badgeText;
  final ScorecardStatus status;

  const ScorecardItemData({
    required this.label,
    required this.value,
    required this.badgeText,
    required this.status,
  });
}

class OwnerScorecardCardWidget extends StatelessWidget {
  final ValueChanged<ScorecardItemData>? onItemTap;

  const OwnerScorecardCardWidget({
    super.key,
    this.onItemTap,
  });

  static const List<ScorecardItemData> _items = [
    ScorecardItemData(
      label: 'Collections efficiency',
      value: '82%',
      badgeText: 'Healthy',
      status: ScorecardStatus.healthy,
    ),
    ScorecardItemData(
      label: 'On-time fulfilment',
      value: '91%',
      badgeText: 'Healthy',
      status: ScorecardStatus.healthy,
    ),
    ScorecardItemData(
      label: 'Buyback approval rate',
      value: '68%',
      badgeText: 'Watch',
      status: ScorecardStatus.watch,
    ),
    ScorecardItemData(
      label: 'Low-stock exposure',
      value: '₹3.2L',
      badgeText: 'Action',
      status: ScorecardStatus.action,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
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
          // Header Row with Icon & Title
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                size: 22.sp,
                color: AppColor.cockpitOrange,
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
          ...List.generate(_items.length, (index) {
            final item = _items[index];
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
                    onTap: () {
                      if (onItemTap != null) {
                        onItemTap!(item);
                      } else {
                        AppSnackBarWidget.show(
                          context,
                          message: '${item.label}: ${item.value} (${item.badgeText})',
                          type: ToastType.info,
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.label,
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
                            item.value,
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
    );
  }

  Widget _buildBadge(BuildContext context, ScorecardItemData item) {
    final theme = Theme.of(context);
    final isHealthy = item.status == ScorecardStatus.healthy;

    return Container(
      constraints: BoxConstraints(minWidth: 62.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isHealthy ? AppColor.customerBadgeGreen : AppColor.transparent,
        borderRadius: BorderRadius.circular(6.r),
        border: isHealthy
            ? null
            : Border.all(
                color: AppColor.metricCardBorder,
                width: 1.2,
              ),
      ),
      child: Center(
        child: Text(
          item.badgeText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isHealthy ? AppColor.white : AppColor.black,
            fontWeight: isHealthy ? FontWeight.w700 : FontWeight.w600,
            fontSize: 11.5.sp,
          ),
          softWrap: true,
        ),
      ),
    );
  }
}
