import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
// import 'package:go_router/go_router.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';
import '../bloc/customer_details_bloc/customer_details_bloc.dart';
import 'customer_detail_item.dart';
import 'customer_timeline_event.dart';

class CustomerOnboardingCardWidget extends StatelessWidget {
  final CustomerDetailItem? customer;
  final String? customerId;

  const CustomerOnboardingCardWidget({
    super.key,
    this.customer,
    this.customerId,
  });

  static const List<CustomerTimelineEvent> _fallbackTimelineEvents = [
    CustomerTimelineEvent(
      date: '10 Sep 2026',
      title: 'Onboarded and machine assigned',
      badgeText: 'Approved',
    ),
    CustomerTimelineEvent(
      date: '10 Sep 2026',
      title: 'Payment received · ₹10,000',
      badgeText: 'Completed',
    ),
    CustomerTimelineEvent(
      date: '10 Sep 2026',
      title: 'Payment received · ₹10,000',
      badgeText: 'Completed',
    ),
    CustomerTimelineEvent(
      date: '10 Sep 2026',
      title: 'Payment received · ₹2,46,000',
      badgeText: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<CustomerDetailsBloc, CustomerDetailsState>(
      listener: (context, state) {
        if (state is CustomerDetailsFailureState) {
          AppSnackBarWidget.show(
            context,
            message: state.message,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is CustomerDetailsLoadingState;

        if (state is CustomerDetailsFailureState && customer == null) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
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
                    state.message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColor.brightRed,
                      fontWeight: FontWeight.w500,
                    ),
                    softWrap: true,
                  ),
                  14.hS,
                  TextButton.icon(
                    onPressed: () {
                      final id = customerId ?? customer?.id;
                      if (id != null && id.isNotEmpty) {
                        context
                            .read<CustomerDetailsBloc>()
                            .add(GetCustomerDetailsEvent(id));
                      }
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Retry'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Use live data from CustomerDetailsSuccessState if available, otherwise fallback/placeholder data
        final details =
            state is CustomerDetailsSuccessState ? state.data.data : null;

        final displayName = details != null && details.fullName.isNotEmpty
            ? details.fullName
            : (customer?.name ?? 'Akshay Sathe');

        final displayCode = details != null && details.customerCode.isNotEmpty
            ? details.customerCode
            : (customer?.code ?? 'CUST-0001');

        final displaySubtitle = details != null && details.subtitle.isNotEmpty
            ? details.subtitle
            : (details != null && details.onboardedDate.isNotEmpty
                ? '$displayCode · onboarded ${details.onboardedDate}'
                : (customer != null
                    ? '$displayCode · onboarded 24 Aug 2026'
                    : 'CUST-0001 · onboarded 24 Aug 2026'));

        final displayPhone =
            details != null && details.formattedMobileNo.isNotEmpty
                ? details.formattedMobileNo
                : (details != null && details.mobileNo.isNotEmpty
                    ? details.mobileNo
                    : (customer?.phone ?? '97674 10452'));

        final displayCity = details != null && details.cityName.isNotEmpty
            ? details.cityName
            : (details?.location?.name.isNotEmpty == true
                ? details!.location!.name
                : (customer?.city ?? 'Kolhapur'));

        final displayAmount =
            details != null && details.formattedAmount.isNotEmpty
                ? details.formattedAmount
                : (details?.lifetimeBusinessValue?.formattedAmount.isNotEmpty ==
                        true
                    ? details!.lifetimeBusinessValue!.formattedAmount
                    : (customer?.amount ?? '₹2,66,000'));

        List<CustomerTimelineEvent> timelineEvents = [];
        if (details != null && details.historyFromOnboarding.isNotEmpty) {
          timelineEvents = details.historyFromOnboarding
              .map((e) => e.toTimelineEvent())
              .toList();
        } else {
          timelineEvents = _fallbackTimelineEvents;
        }

        return Skeletonizer(
          enabled: isLoading,
          child: Container(
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
                // Header Row: Customer Name & Subtitle
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
                            displaySubtitle,
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
                    // "Back to list" button commented out per user request
                    // InkWell(
                    //   borderRadius: BorderRadius.circular(8.r),
                    //   onTap: () {
                    //     if (context.canPop()) {
                    //       context.pop();
                    //     } else {
                    //       context.go('/customers');
                    //     }
                    //   },
                    //   child: Padding(
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                    //     child: Text(
                    //       'Back to list',
                    //       style: theme.textTheme.labelMedium?.copyWith(
                    //         fontSize: 13.sp,
                    //         fontWeight: FontWeight.w600,
                    //         color: AppColor.cockpitOrange,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                16.hS,

                // Contact and Location 2-Column Row
                Row(
                  children: [
                    // Contact Card
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 14.h),
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
                            Skeleton.ignore(
                              child: Text(
                                'Contact',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.textSecondary,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.wS,

                    // Location Card
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 14.h),
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
                            Skeleton.ignore(
                              child: Text(
                                'Location',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.textSecondary,
                                ),
                                softWrap: true,
                              ),
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
                      Skeleton.ignore(
                        child: Text(
                          'Lifetime business value',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.charcoal,
                          ),
                          softWrap: true,
                        ),
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

                // Section Title: History from onboarding (kept as is via Skeleton.ignore)
                Skeleton.ignore(
                  child: Text(
                    'History from onboarding',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.black,
                    ),
                    softWrap: true,
                  ),
                ),
                14.hS,

                // Timeline items list or Empty Message
                if (!isLoading && details != null && details.historyFromOnboarding.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Center(
                      child: Text(
                        'No onboarding history found',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: timelineEvents.length,
                    separatorBuilder: (context, index) => 14.hS,
                    itemBuilder: (context, index) {
                      final event = timelineEvents[index];
                      return _buildTimelineRow(theme, event);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimelineRow(ThemeData theme, CustomerTimelineEvent event) {
    Color badgeColor = AppColor.customerBadgeGreen;
    final text = event.badgeText.toLowerCase();
    if (text.contains('reject') ||
        text.contains('fail') ||
        text.contains('cancel')) {
      badgeColor = AppColor.pendingBadgeRed;
    }

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
                    color: badgeColor,
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
