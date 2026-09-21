import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../remote/models/bookings_model/pending_advance_booking_details_response.dart';
import '../../bloc/pending_advance_booking_details_bloc/pending_advance_booking_details_bloc.dart';
import 'pending_advance_booking_details_header_widget.dart';

class PendingAdvanceBookingDetailsContentWidget extends StatelessWidget {
  final String bookingId;

  const PendingAdvanceBookingDetailsContentWidget({
    super.key,
    required this.bookingId,
  });

  String _formatDate(String rawDate) {
    if (rawDate.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(rawDate).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final month = months[dateTime.month - 1];
      final day = dateTime.day.toString().padLeft(2, '0');
      final hour = dateTime.hour > 12
          ? dateTime.hour - 12
          : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final ampm = dateTime.hour >= 12 ? 'PM' : 'AM';
      return '$day $month ${dateTime.year}, $hour:$minute $ampm';
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingAdvanceBookingDetailsBloc,
        PendingAdvanceBookingDetailsState>(
      builder: (context, state) {
        final isLoading = state is PendingAdvanceBookingDetailsLoadingState;
        final isFailure = state is PendingAdvanceBookingDetailsFailureState;
        final isSuccess = state is PendingAdvanceBookingDetailsSuccessState;

        final details = isSuccess ? state.data.data : null;
        final headerTitle = details?.bookingId.isNotEmpty == true
            ? details!.bookingId
            : 'Booking Details';

        return RefreshIndicator(
          color: AppColor.primary,
          backgroundColor: AppColor.pureWhite,
          onRefresh: () async {
            if (bookingId.isNotEmpty) {
              context.read<PendingAdvanceBookingDetailsBloc>().add(
                    RefreshPendingAdvanceBookingDetailsEvent(bookingId),
                  );
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.hS,
                PendingAdvanceBookingDetailsHeaderWidget(title: headerTitle),
                12.hS,

                // 1. Loading State with Skeletonizer
                if (isLoading)
                  Skeletonizer(
                    enabled: true,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          _buildCardSkeleton(),
                          12.hS,
                          _buildCardSkeleton(),
                          12.hS,
                          _buildCardSkeleton(),
                        ],
                      ),
                    ),
                  )
                // 2. Error State with Retry
                else if (isFailure)
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 40.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 28.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.pureWhite,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColor.metricCardBorder,
                          width: 1.1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 46.sp,
                            color: AppColor.brightRed,
                          ),
                          12.hS,
                          Text(
                            state.message,
                            style: TextStyle(
                              color: AppColor.charcoal,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                          16.hS,
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              foregroundColor: AppColor.pureWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 10.h,
                              ),
                            ),
                            onPressed: () {
                              if (bookingId.isNotEmpty) {
                                context
                                    .read<PendingAdvanceBookingDetailsBloc>()
                                    .add(
                                      GetPendingAdvanceBookingDetailsEvent(
                                        bookingId,
                                      ),
                                    );
                              }
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                // 3. Success State with Details Cards
                else if (details != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card 1: Machine & Booking Overview
                        _buildOverviewCard(context, details),
                        14.hS,

                        // Card 2: Customer Information
                        if (details.customer != null) ...[
                          _buildCustomerCard(context, details),
                          14.hS,
                        ],

                        // Card 3: Financial Summary
                        _buildFinancialCard(context, details),
                        16.hS,

                        // Card 4: Advance Entries
                        _buildAdvanceEntriesCard(context, details),
                        24.hS,
                      ],
                    ),
                  )
                else
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Text(
                        'No details available',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColor.slateGrey,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardSkeleton() {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.metricCardBorder),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    PendingAdvanceBookingDetailsData details,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.metricCardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColor.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  details.bookingId.isNotEmpty ? details.bookingId : 'Booking',
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (details.createdAt.isNotEmpty)
                Text(
                  _formatDate(details.createdAt),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColor.slateGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          12.hS,
          Text(
            'Item / Machine',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColor.slateGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          4.hS,
          Text(
            details.itemTitle.isNotEmpty ? details.itemTitle : '—',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.charcoal,
              height: 1.3,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(
    BuildContext context,
    PendingAdvanceBookingDetailsData details,
  ) {
    final customer = details.customer!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.metricCardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.slateGrey,
              letterSpacing: 0.3,
            ),
          ),
          12.hS,
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColor.avatarBg,
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 20.sp,
                  color: AppColor.primary,
                ),
              ),
              12.wS,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.fullName.isNotEmpty ? customer.fullName : '—',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.charcoal,
                      ),
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (customer.mobileNo.isNotEmpty) ...[
                      3.hS,
                      Text(
                        customer.mobileNo,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColor.slateGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(
    BuildContext context,
    PendingAdvanceBookingDetailsData details,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.metricCardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Financial Summary',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.slateGrey,
              letterSpacing: 0.3,
            ),
          ),
          14.hS,
          Row(
            children: [
              // Total Amount
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColor.subCardBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColor.slateGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      4.hS,
                      Text(
                        details.formattedTotalAmount.isNotEmpty
                            ? details.formattedTotalAmount
                            : '₹${details.totalAmount}',
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.charcoal,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
              12.wS,
              // Pending Advance
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColor.pendingBadgeRed.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColor.pendingBadgeRed.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Advance',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColor.pendingBadgeRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      4.hS,
                      Text(
                        details.formattedPendingAdvanceAmount.isNotEmpty
                            ? details.formattedPendingAdvanceAmount
                            : '₹${details.pendingAdvanceAmount}',
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.pendingBadgeRed,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvanceEntriesCard(
    BuildContext context,
    PendingAdvanceBookingDetailsData details,
  ) {
    final entries = details.advanceEntries;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.metricCardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advance Entries',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.charcoal,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColor.avatarBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '${entries.length} ${entries.length == 1 ? 'entry' : 'entries'}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ],
          ),
          12.hS,
          if (entries.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Text(
                  'No advance entries found.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColor.slateGrey,
                  ),
                ),
              ),
            )
          else
            Column(
              children: List.generate(
                entries.length,
                (index) => _buildEntryItem(entries[index], isLast: index == entries.length - 1),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEntryItem(AdvanceEntryItem entry, {bool isLast = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColor.subCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColor.metricCardBorder.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Amount
              Text(
                '₹${entry.amount}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColor.charcoal,
                ),
              ),
              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: entry.isApproved
                      ? AppColor.customerBadgeGreen.withValues(alpha: 0.1)
                      : AppColor.pendingBadgeRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: entry.isApproved
                        ? AppColor.customerBadgeGreen.withValues(alpha: 0.3)
                        : AppColor.pendingBadgeRed.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      entry.isApproved
                          ? Icons.check_circle_outline_rounded
                          : Icons.hourglass_top_rounded,
                      size: 11.sp,
                      color: entry.isApproved
                          ? AppColor.customerBadgeGreen
                          : AppColor.pendingBadgeRed,
                    ),
                    4.wS,
                    Text(
                      entry.isApproved ? 'Approved' : 'Pending',
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        color: entry.isApproved
                            ? AppColor.customerBadgeGreen
                            : AppColor.pendingBadgeRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.hS,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Payment Mode
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 13.sp,
                    color: AppColor.slateGrey,
                  ),
                  4.wS,
                  Text(
                    entry.paymentModeName.isNotEmpty
                        ? entry.paymentModeName
                        : 'Payment Mode',
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.slateGrey,
                    ),
                  ),
                ],
              ),
              // Created At
              if (entry.createdAt.isNotEmpty)
                Text(
                  _formatDate(entry.createdAt),
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: AppColor.slateGrey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
