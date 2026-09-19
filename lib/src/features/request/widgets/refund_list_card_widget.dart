import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../../remote/models/request_model/refunds_response.dart';

class RefundListCardWidget extends StatelessWidget {
  final List<RefundItem> items;
  final ValueChanged<RefundItem>? onItemTap;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const RefundListCardWidget({
    super.key,
    required this.items,
    this.onItemTap,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.onRetry,
  });

  static const RefundItem _skeletonRefund = RefundItem(
    id: 'skeleton-id',
    refundNo: 'RF-1-2026-001',
    amount: 10202.4,
    formattedAmount: '₹10,202.40',
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. Initial Loading State using Skeletonizer
    if (isLoading) {
      return Skeletonizer(
        enabled: true,
        child: Column(
          children: List.generate(
            10,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == 9 ? 0 : 12.h),
              child: _buildRefundItemCard(context, _skeletonRefund),
            ),
          ),
        ),
      );
    }

    // 2. Error State with Retry
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.metricCardBorder, width: 1.1),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.02),
              blurRadius: 8,
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
                size: 36.sp,
              ),
              10.hS,
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
                14.hS,
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColor.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // 3. Empty State
    if (items.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 36.h),
        decoration: BoxDecoration(
          color: AppColor.pureWhite,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.metricCardBorder, width: 1.1),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: AppColor.slateGrey,
                size: 40.sp,
              ),
              10.hS,
              Text(
                'No refund requests found',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColor.slateGrey,
                  fontWeight: FontWeight.w500,
                ),
                softWrap: true,
              ),
            ],
          ),
        ),
      );
    }

    // 4. List of Standalone Refund Cards matching Customer list format
    return Column(
      children: [
        ...List.generate(items.length, (index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 && !isLoadingMore ? 0 : 12.h,
            ),
            child: _buildRefundItemCard(context, item),
          );
        }),
        if (isLoadingMore)
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Skeletonizer(
              enabled: true,
              child: _buildRefundItemCard(context, _skeletonRefund),
            ),
          ),
      ],
    );
  }

  Widget _buildRefundItemCard(BuildContext context, RefundItem item) {
    final theme = Theme.of(context);

    final customerName = item.customer?.fullName.isNotEmpty == true
        ? item.customer!.fullName
        : 'Customer';

    final initials = item.customer?.initials.isNotEmpty == true
        ? item.customer!.initials
        : (customerName.isNotEmpty ? customerName[0].toUpperCase() : 'RF');

    final phone = item.customer?.mobileNo ?? '';
    final city = item.customer?.cityName.isNotEmpty == true
        ? item.customer!.cityName
        : (item.customer?.city?.title ?? '');

    final phoneCitySubtitle = [
      if (phone.isNotEmpty) phone,
      if (city.isNotEmpty) city,
    ].join(' · ');

    final itemTitle = item.order?.itemTitle ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.metricCardBorder, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColor.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onItemTap != null ? () => onItemTap!(item) : null,
          splashColor: AppColor.orangeTint2.withValues(alpha: 0.5),
          highlightColor: AppColor.orangeTint2.withValues(alpha: 0.3),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                // Avatar Circle Badge
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: const BoxDecoration(
                    color: AppColor.avatarBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5.sp,
                      ),
                    ),
                  ),
                ),
                14.wS,

                // Customer Name & Subtitle Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (phoneCitySubtitle.isNotEmpty) ...[
                        3.hS,
                        Text(
                          phoneCitySubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColor.textSecondary,
                          ),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (itemTitle.isNotEmpty) ...[
                        2.hS,
                        Text(
                          itemTitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.cockpitOrange,
                          ),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                10.wS,

                // Amount, Status Badge & Refund No
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.formattedAmount.isNotEmpty
                          ? item.formattedAmount
                          : '₹${item.amount}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.black,
                      ),
                      maxLines: 1,
                      softWrap: true,
                    ),
                    4.hS,
                    // Status Badge
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: _getStatusBgColor(item.status),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        item.statusLabel.isNotEmpty
                            ? item.statusLabel
                            : (item.status.isNotEmpty
                                ? item.status
                                : item.refundNo),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                          color: _getStatusTextColor(item.status),
                        ),
                      ),
                    ),
                    3.hS,
                    Text(
                      item.refundNo,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textSecondary,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
                8.wS,

                // Right chevron
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.sp,
                  color: AppColor.slateGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'settled':
        return AppColor.customerBadgeGreen.withValues(alpha: 0.12);
      case 'approved':
        return AppColor.primary.withValues(alpha: 0.12);
      case 'rejected':
        return AppColor.brightRed.withValues(alpha: 0.12);
      case 'processing':
      case 'requested':
      default:
        return AppColor.orangeTint2;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'settled':
        return AppColor.customerBadgeGreen;
      case 'approved':
        return AppColor.primary;
      case 'rejected':
        return AppColor.brightRed;
      case 'processing':
      case 'requested':
      default:
        return AppColor.primary;
    }
  }
}
