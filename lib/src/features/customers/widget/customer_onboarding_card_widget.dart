import 'package:admin_navudyojak/src/features/customers/widget/customer_detail_item.dart';
import 'package:admin_navudyojak/src/features/customers/widget/customer_timeline_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

class CustomerOnboardingCardWidget extends StatelessWidget {
  final CustomerDetailItem? customer;

  const CustomerOnboardingCardWidget({
    super.key,
    this.customer,
  });

  static const List<CustomerTimelineEvent> _timelineEvents = [
    CustomerTimelineEvent(
      date: '12 Jan 2026',
      title: 'Onboarded and machine assigned',
      badgeText: 'Approved',
    ),
    CustomerTimelineEvent(
      date: '18 Aug 2026',
      title: 'Raw material issued · 240 kg',
      badgeText: 'Completed',
    ),
    CustomerTimelineEvent(
      date: '22 Aug 2026',
      title: 'Finished goods received · 186 units',
      badgeText: 'Completed',
    ),
    CustomerTimelineEvent(
      date: '24 Aug 2026',
      title: 'Payment received · ₹42,500',
      badgeText: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final displayName = customer?.name ?? 'Sonal Jadhav';
    final displayCode = customer?.code ?? 'CUST-1240';
    final displayPhone = customer?.phone ?? '97855 12348';
    final displayCity = customer?.city ?? 'Pune';
    final displayAmount = customer?.amount ?? '₹91,200';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Customer Name + Back to list link
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColor.black,
                        letterSpacing: -0.2,
                      ),
                      softWrap: true,
                    ),
                    4.hS,
                    Text(
                      '$displayCode · onboarded 12 Jan 2026',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColor.textSecondary,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/customers');
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Text(
                    'Back to list',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.cockpitOrange,
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.hS,

          // Contact and Location 2-Column Row
          Row(
            children: [
              // Contact Card
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColor.subCardBg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 20.sp,
                        color: AppColor.cockpitOrange,
                      ),
                      10.hS,
                      Text(
                        displayPhone,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                        softWrap: true,
                      ),
                      2.hS,
                      Text(
                        'Contact',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.textSecondary,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
              12.wS,

              // Location Card
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColor.subCardBg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 20.sp,
                        color: AppColor.cockpitOrange,
                      ),
                      10.hS,
                      Text(
                        displayCity,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                        softWrap: true,
                      ),
                      2.hS,
                      Text(
                        'Location',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.textSecondary,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          16.hS,

          // Lifetime business value Box
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColor.pureWhite,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColor.metricCardBorder,
                width: 1.1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lifetime business value',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.charcoal,
                  ),
                  softWrap: true,
                ),
                Text(
                  displayAmount,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.black,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          20.hS,

          // Section Title: History from onboarding
          Text(
            'History from onboarding',
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
            softWrap: true,
          ),
          14.hS,

          // Timeline items list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _timelineEvents.length,
            separatorBuilder: (context, index) => 14.hS,
            itemBuilder: (context, index) {
              final event = _timelineEvents[index];
              return _buildTimelineRow(theme, event);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineRow(ThemeData theme, CustomerTimelineEvent event) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Vertical timeline peach/orange line
          Container(
            width: 2.5.w,
            decoration: BoxDecoration(
              color: AppColor.cockpitSubtitle,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          12.wS,

          // Date column
          SizedBox(
            width: 82.w,
            child: Text(
              event.date,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.slateGrey,
              ),
              softWrap: true,
            ),
          ),
          8.wS,

          // Title & Badge column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                    height: 1.25,
                  ),
                  softWrap: true,
                ),
                6.hS,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.customerBadgeGreen,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    event.badgeText,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColor.pureWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
