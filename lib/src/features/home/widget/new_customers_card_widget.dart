import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

import 'package:go_router/go_router.dart';

import '../../../routes/app_route_path.dart';
import 'new_customer_item.dart';

class NewCustomersCardWidget extends StatelessWidget {
  final List<NewCustomerItem> items;
  final int? newThisWeekCount;
  final ValueChanged<NewCustomerItem>? onItemTap;
  final VoidCallback? onViewAllTap;

  const NewCustomersCardWidget({
    super.key,
    this.items = defaultCustomers,
    this.newThisWeekCount,
    this.onItemTap,
    this.onViewAllTap,
  });

  static const List<NewCustomerItem> defaultCustomers = [
    NewCustomerItem(
      initials: 'SS',
      name: 'Sunita Sharma',
      subtitle: 'Pune · Today',
      amount: '₹1.82L',
    ),
    NewCustomerItem(
      initials: 'VP',
      name: 'Vijay Pawar',
      subtitle: 'Nashik · Yesterday',
      amount: '₹94,500',
    ),
    NewCustomerItem(
      initials: 'NK',
      name: 'Neha Kulkarni',
      subtitle: 'Kolhapur · Yesterday',
      amount: '₹68,200',
    ),
    NewCustomerItem(
      initials: 'RJ',
      name: 'Ramesh Jagtap',
      subtitle: 'Satara · 22 Aug',
      amount: '₹1.14L',
    ),
    NewCustomerItem(
      initials: 'PG',
      name: 'Pooja Gaikwad',
      subtitle: 'Pune · 21 Aug',
      amount: '₹52,800',
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
          // Title
          Text(
            'New customers onboarded',
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
            'Latest businesses entering the program',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
            ),
            softWrap: true,
          ),
          10.hS,

          // Green "this week" Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColor.customerBadgeGreen,
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Text(
              '${newThisWeekCount ?? items.length} this week',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.w700,
                fontSize: 11.5.sp,
              ),
              softWrap: true,
            ),
          ),
          16.hS,

          // List of Customers Cards or Empty State
          if (items.isEmpty)
            _buildEmptyState(theme)
          else
            ...List.generate(items.length, (index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == items.length - 1 ? 0 : 10.h,
                ),
                child: _buildCustomerCard(context, item),
              );
            }),
          14.hS,

          // View all customers button
          Material(
            color: AppColor.card,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                if (onViewAllTap != null) {
                  onViewAllTap!();
                } else {
                  context.go(AppRoute.customers.path);
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
                      'View all customers',
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

  Widget _buildCustomerCard(BuildContext context, NewCustomerItem item) {
    final theme = Theme.of(context);

    return Material(
      color: AppColor.card,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onItemTap != null ? () => onItemTap!(item) : null,
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
              // Avatar
              Container(
                width: 40.r,
                height: 40.r,
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
                      fontSize: 13.5.sp,
                    ),
                  ),
                ),
              ),
              12.wS,

              // Name and Subtitle
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
                  ],
                ),
              ),
              8.wS,

              // Amount & Lifetime Value
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
                    'lifetime value',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textSecondary,
                    ),
                    softWrap: true,
                  ),
                ],
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
            Icons.people_outline_rounded,
            size: 32.sp,
            color: AppColor.slateGrey,
          ),
          8.hS,
          Text(
            'No new customers this week',
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
