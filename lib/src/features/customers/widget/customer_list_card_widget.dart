import 'package:admin_navudyojak/src/features/customers/widget/customer_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';

class CustomerListCardWidget extends StatelessWidget {
  final List<CustomerDetailItem> items;
  final ValueChanged<CustomerDetailItem>? onItemTap;

  const CustomerListCardWidget({
    super.key,
    required this.items,
    this.onItemTap,
  });

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
          // Title
          Text(
            'Latest 10 customers',
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
            'Search any customer to view complete history.',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
            ),
            softWrap: true,
          ),
          16.hS,

          // Empty state
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  'No customers found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColor.slateGrey,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                ),
              ),
            )
          else
            ...List.generate(items.length, (index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == items.length - 1 ? 0 : 10.h,
                ),
                child: _buildCustomerItemCard(context, item),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildCustomerItemCard(BuildContext context, CustomerDetailItem item) {
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
              message: '${item.name} (${item.code}) selected',
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
            border: Border.all(
              color: AppColor.metricCardBorder,
              width: 1.1,
            ),
          ),
          child: Row(
            children: [
              // Avatar Circle
              Container(
                width: 42.r,
                height: 42.r,
                decoration: const BoxDecoration(
                  color: AppColor.avatarBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item.initials,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColor.cockpitOrange,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              12.wS,

              // Name and Phone · City
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                    3.hS,
                    Text(
                      '${item.phone} · ${item.city}',
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
              6.wS,

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
    );
  }
}
