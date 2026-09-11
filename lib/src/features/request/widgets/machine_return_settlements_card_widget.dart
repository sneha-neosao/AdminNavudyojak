import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';
import 'request_item_data.dart';

class MachineReturnSettlementsCardWidget extends StatelessWidget {
  final List<RequestItemData> items;
  final ValueChanged<RequestItemData>? onEditTap;
  final ValueChanged<RequestItemData>? onConfirmTap;

  const MachineReturnSettlementsCardWidget({
    super.key,
    this.items = defaultItems,
    this.onEditTap,
    this.onConfirmTap,
  });

  static const List<RequestItemData> defaultItems = [
    RequestItemData(
      name: 'Rajesh Patil',
      code: 'RET-209',
      badgeText: 'QC approved',
      isApproved: true,
      subtitle: 'Machine + raw material · 12 Aug 2026',
      amount: '₹ 45,000',
    ),
    RequestItemData(
      name: 'Meena Shinde',
      code: 'RET-208',
      badgeText: 'Awaiting review',
      isApproved: false,
      subtitle: 'Finished goods settlement · 11 Aug 2026',
      amount: '₹ 28,500',
    ),
    RequestItemData(
      name: 'Amit Deshmukh',
      code: 'RET-207',
      badgeText: 'Awaiting review',
      isApproved: false,
      subtitle: 'Machine return · 10 Aug 2026',
      amount: '₹ 62,000',
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
                Icons.replay_rounded,
                size: 20.sp,
                color: AppColor.cockpitOrange,
              ),
              8.wS,
              Expanded(
                child: Text(
                  'Machine return settlements',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
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
            'Review machine condition, raw material variance, and final payout before confirmation.',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
              height: 1.35,
            ),
            softWrap: true,
          ),
          16.hS,

          // Request Cards List
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : 14.h,
              ),
              child: _buildRequestCard(context, item),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, RequestItemData item) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.metricCardBorder,
          width: 1.2,
        ),
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
                        item.name,
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
                      ' · ${item.code}',
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
                  color: item.isApproved
                      ? AppColor.customerBadgeGreen
                      : AppColor.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                  border: item.isApproved
                      ? null
                      : Border.all(
                          color: AppColor.metricCardBorder,
                          width: 1.2,
                        ),
                ),
                child: Text(
                  item.badgeText,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: item.isApproved ? AppColor.white : AppColor.black,
                    fontWeight:
                        item.isApproved ? FontWeight.w700 : FontWeight.w600,
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
            item.subtitle,
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
                  item.amount,
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
          12.hS,

          // Action Buttons: Edit value & Confirm approval
          Row(
            children: [
              // Edit Value Button
              Expanded(
                child: Material(
                  color: AppColor.card,
                  borderRadius: BorderRadius.circular(10.r),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: () {
                      if (onEditTap != null) {
                        onEditTap!(item);
                      } else {
                        AppSnackBarWidget.show(
                          context,
                          message: 'Edit value for ${item.name}',
                          type: ToastType.info,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColor.metricCardBorder,
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Edit value',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              10.wS,

              // Confirm Approval Button
              Expanded(
                child: Material(
                  color: AppColor.cockpitOrange,
                  borderRadius: BorderRadius.circular(10.r),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: () {
                      if (onConfirmTap != null) {
                        onConfirmTap!(item);
                      } else {
                        AppSnackBarWidget.show(
                          context,
                          message: 'Approved settlement for ${item.name}',
                          type: ToastType.success,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          'Confirm approval',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.white,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
