import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../../remote/models/request_model/refunds_response.dart';

class MachineReturnSettlementsCardWidget extends StatelessWidget {
  final List<RefundItem> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const MachineReturnSettlementsCardWidget({
    super.key,
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.onRetry,
  });

  static const RefundItem _skeletonRefund = RefundItem(
    id: 'skeleton-id',
    refundNo: 'RF-1-2026-001',
    amount: 10202.4,
    formattedAmount: '₹ 10,202.40',
    status: 'settled',
    statusLabel: 'Settled',
    customer: RefundCustomer(
      fullName: 'Rajesh Patil',
      initials: 'RP',
      mobileNo: '9356993299',
      cityName: 'Kolhapur',
    ),
    order: RefundOrder(
      itemTitle: 'Diamond Supari Cutting Machine',
    ),
  );

  static String _formatDate(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      const months = [
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
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Loading State with Skeletonizer
    if (isLoading) {
      return Skeletonizer(
        enabled: true,
        child: Column(
          children: List.generate(
            10,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == 9 ? 0 : 14.h),
              child: _buildRequestCard(context, _skeletonRefund),
            ),
          ),
        ),
      );
    }

    // Error State
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColor.card,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.metricCardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppColor.brightRed,
                size: 32.sp,
              ),
              8.hS,
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColor.brightRed,
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
              ),
              if (onRetry != null) ...[
                12.hS,
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColor.cockpitOrange,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Empty State
    if (items.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 36.h),
        decoration: BoxDecoration(
          color: AppColor.card,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.metricCardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.replay_rounded,
                size: 36.sp,
                color: AppColor.slateGrey,
              ),
              8.hS,
              Text(
                'No refund requests found',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColor.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
              ),
            ],
          ),
        ),
      );
    }

    // Request Cards List
    return Column(
      children: [
        ...List.generate(items.length, (index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 && !isLoadingMore ? 0 : 14.h,
            ),
            child: _buildRequestCard(context, item),
          );
        }),
        if (isLoadingMore)
          Padding(
            padding: EdgeInsets.only(top: 14.h),
            child: Skeletonizer(
              enabled: true,
              child: _buildRequestCard(context, _skeletonRefund),
            ),
          ),
      ],
    );
  }

  Widget _buildRequestCard(BuildContext context, RefundItem item) {
    final theme = Theme.of(context);

    final customerName = item.customer?.fullName.isNotEmpty == true
        ? item.customer!.fullName
        : 'Customer';
    final code = item.refundNo.isNotEmpty ? item.refundNo : 'RET-000';

    final subtitleParts = <String>[];
    if (item.order?.itemTitle.isNotEmpty == true) {
      subtitleParts.add(item.order!.itemTitle);
    } else if (item.order?.orderType.isNotEmpty == true) {
      subtitleParts.add(item.order!.orderType);
    }
    if (item.createdAt.isNotEmpty) {
      subtitleParts.add(_formatDate(item.createdAt));
    }
    final subtitle = subtitleParts.isNotEmpty
        ? subtitleParts.join(' · ')
        : (item.reason.isNotEmpty ? item.reason : 'Machine return');

    final amountStr = item.formattedAmount.isNotEmpty
        ? item.formattedAmount
        : '₹ ${item.amount}';

    final statusLower = item.status.toLowerCase();
    final isApproved =
        statusLower == 'settled' || statusLower == 'approved';
    final badgeText = item.statusLabel.isNotEmpty
        ? item.statusLabel
        : (item.status.isNotEmpty ? item.status : 'Pending');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.metricCardBorder, width: 1.2),
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
        children: [
          // Name, Code and Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        customerName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      ' · $code',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.slateGrey,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              8.wS,

              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isApproved
                      ? AppColor.customerBadgeGreen
                      : (statusLower == 'rejected'
                          ? AppColor.brightRed
                          : AppColor.transparent),
                  borderRadius: BorderRadius.circular(6.r),
                  border: isApproved || statusLower == 'rejected'
                      ? null
                      : Border.all(
                          color: AppColor.metricCardBorder,
                          width: 1.2,
                        ),
                ),
                child: Text(
                  badgeText,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isApproved || statusLower == 'rejected'
                        ? AppColor.white
                        : AppColor.black,
                    fontWeight: isApproved
                        ? FontWeight.w700
                        : FontWeight.w600,
                    fontSize: 11.5.sp,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          4.hS,

          // Subtitle
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
            ),
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          12.hS,

          // Proposed Settlement Container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColor.subCardBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Proposed settlement',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textSecondary,
                  ),
                  softWrap: true,
                ),
                Text(
                  amountStr,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.black,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
