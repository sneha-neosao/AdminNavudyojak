import 'package:admin_navudyojak/src/features/customers/widget/customer_detail_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';

class CustomerListCardWidget extends StatelessWidget {
  final List<CustomerDetailItem> items;
  final ValueChanged<CustomerDetailItem>? onItemTap;
  final bool isLoading;
  final bool isLoadingMore;
  final String? title;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const CustomerListCardWidget({
    super.key,
    required this.items,
    this.onItemTap,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.title,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. Initial Loading State
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoActivityIndicator(
                color: AppColor.primary,
                radius: 14.r,
              ),
              12.hS,
              Text(
                'Loading customers...',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColor.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
            ],
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
          border: Border.all(
            color: AppColor.metricCardBorder,
            width: 1.1,
          ),
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
          border: Border.all(
            color: AppColor.metricCardBorder,
            width: 1.1,
          ),
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
                Icons.person_off_outlined,
                color: AppColor.slateGrey,
                size: 40.sp,
              ),
              10.hS,
              Text(
                'No customers found',
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

    // 4. List of Standalone Customer Cards
    return Column(
      children: [
        ...List.generate(items.length, (index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 && !isLoadingMore ? 0 : 12.h,
            ),
            child: _buildCustomerItemCard(context, item),
          );
        }),
        if (isLoadingMore)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Center(
              child: CupertinoActivityIndicator(
                color: AppColor.primary,
                radius: 12.r,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCustomerItemCard(BuildContext context, CustomerDetailItem item) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.metricCardBorder,
          width: 1.1,
        ),
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
          onTap: () {
            if (onItemTap != null) {
              onItemTap!(item);
            } else {
              AppSnackBarWidget.show(
                context,
                message: '${item.name} (${item.code}) selected',
                type: ToastType.info,
              );
            }
          },
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
                      item.initials,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5.sp,
                      ),
                    ),
                  ),
                ),
                14.wS,

                // Name and Phone · City
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      3.hS,
                      Text(
                        '${item.phone} · ${item.city}',
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
                  ),
                ),
                10.wS,

                // Amount & Customer Code
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
                      item.code,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 11.5.sp,
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
}
