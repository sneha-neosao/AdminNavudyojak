import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

import 'package:go_router/go_router.dart';

import '../../../routes/app_route_path.dart';
import '../../widgets/app_snackbar_widget.dart';
import 'return_settlement_item.dart';

class ReturnSettlementCardWidget extends StatelessWidget {
  final List<ReturnSettlementItem> items;
  final int? pendingCount;
  final ValueChanged<ReturnSettlementItem>? onItemTap;
  final VoidCallback? onViewAllTap;

  const ReturnSettlementCardWidget({
    super.key,
    this.items = defaultItems,
    this.pendingCount,
    this.onItemTap,
    this.onViewAllTap,
  });

  static const List<ReturnSettlementItem> defaultItems = [
    ReturnSettlementItem(
      name: 'Rajesh Patil',
      code: 'RET-209',
      description: 'Raw material + machine',
      amount: '₹45,000',
    ),
    ReturnSettlementItem(
      name: 'Meena Shinde',
      code: 'RET-208',
      description: 'Finished goods settlement',
      amount: '₹28,500',
    ),
    ReturnSettlementItem(
      name: 'Amit Deshmukh',
      code: 'RET-207',
      description: 'Machine return',
      amount: '₹62,000',
    ),
    ReturnSettlementItem(
      name: 'Kiran More',
      code: 'RET-206',
      description: 'Raw material variance',
      amount: '₹19,800',
    ),
    ReturnSettlementItem(
      name: 'Sonal Jadhav',
      code: 'RET-205',
      description: 'Machine return',
      amount: '₹35,200',
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
              Icon(
                Icons.replay_rounded,
                size: 20.sp,
                color: AppColor.cockpitOrange,
              ),
              8.wS,
              Expanded(
                child: Text(
                  'Return settlement requests',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 17.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.black,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          4.hS,

          // Subtitle
          Text(
            'Edit value before final approval',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
            ),
            softWrap: true,
          ),
          10.hS,

          // Red "pending" Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColor.pendingBadgeRed,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Text(
              '${pendingCount ?? items.length} pending',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.w700,
                fontSize: 11.5.sp,
              ),
              softWrap: true,
            ),
          ),
          16.hS,

          // List of Settlement Cards or Empty State
          if (items.isEmpty)
            _buildEmptyState(theme)
          else
            ...List.generate(items.length, (index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == items.length - 1 ? 0 : 10.h,
                ),
                child: _buildSettlementItemCard(context, item),
              );
            }),
          14.hS,

          // View all requests button
          Material(
            color: AppColor.card,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                if (onViewAllTap != null) {
                  onViewAllTap!();
                } else {
                  context.go(AppRoute.requests.path);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColor.metricCardBorder,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View all requests',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                      softWrap: true,
                    ),
                    6.wS,
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16.sp,
                      color: AppColor.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementItemCard(
    BuildContext context,
    ReturnSettlementItem item,
  ) {
    final theme = Theme.of(context);

    return Material(
      color: AppColor.card,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {
          if (onItemTap != null) {
            onItemTap!(item);
          } else {
            AppSnackBarWidget.show(
              context,
              message: '${item.name} (${item.code}) review selected',
              type: ToastType.info,
            );
          }
        },
        splashColor: AppColor.orangeTint2.withValues(alpha: 0.5),
        highlightColor: AppColor.orangeTint2.withValues(alpha: 0.3),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColor.metricCardBorder, width: 1.1),
          ),
          child: Row(
            children: [
              // Left Content: Name · Code and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          ' · ${item.code}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.slateGrey,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                    4.hS,
                    Text(
                      item.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColor.textSecondary,
                      ),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              8.wS,

              // Right Content: Amount and Review
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.amount,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColor.black,
                    ),
                    maxLines: 1,
                    softWrap: true,
                  ),
                  2.hS,
                  Text(
                    'Review',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.cockpitOrange,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
              6.wS,

              // Arrow Icon
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: AppColor.slateGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 32.sp,
            color: AppColor.customerBadgeGreen,
          ),
          8.hS,
          Text(
            'No pending settlement requests',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColor.textSecondary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
