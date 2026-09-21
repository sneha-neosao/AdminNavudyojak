import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../remote/models/bookings_model/pending_advance_bookings_response.dart';

class PendingAdvanceBookingCardWidget extends StatelessWidget {
  final PendingAdvanceBookingItem item;
  final VoidCallback? onTap;
  final VoidCallback? onApprove;
  final bool isApproving;

  const PendingAdvanceBookingCardWidget({
    super.key,
    required this.item,
    this.onTap,
    this.onApprove,
    this.isApproving = false,
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
    final theme = Theme.of(context);
    final dateStr = _formatDate(item.createdAt);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
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
      child: Material(
        color: AppColor.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Booking ID Badge and Created Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColor.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        item.bookingId.isNotEmpty
                            ? item.bookingId
                            : 'Booking',
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    if (dateStr.isNotEmpty)
                      Text(
                        dateStr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11.sp,
                          color: AppColor.slateGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                10.hS,

                // Machine / Item Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.itemTitle.isNotEmpty
                            ? item.itemTitle
                            : 'Machine / Product',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.charcoal,
                          height: 1.25,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColor.slateGrey,
                      size: 20.sp,
                    ),
                  ],
                ),
                10.hS,

                // Customer Info Row
                if (item.customer != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.subCardBg,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 13.r,
                          backgroundColor: AppColor.avatarBg,
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 15.sp,
                            color: AppColor.primary,
                          ),
                        ),
                        8.wS,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.customer!.fullName.isNotEmpty
                                    ? item.customer!.fullName
                                    : 'Customer',
                                style: TextStyle(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.charcoal,
                                ),
                                softWrap: true,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item.customer!.mobileNo.isNotEmpty) ...[
                                2.hS,
                                Text(
                                  item.customer!.mobileNo,
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
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
                  ),
                12.hS,

                // Amounts Row: Total Amount vs Pending Advance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total Amount
                    Column(
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
                        2.hS,
                        Text(
                          item.formattedTotalAmount.isNotEmpty
                              ? item.formattedTotalAmount
                              : '₹${item.totalAmount}',
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.charcoal,
                          ),
                        ),
                      ],
                    ),

                    // Pending Advance Amount Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.pendingBadgeRed.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColor.pendingBadgeRed.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Pending Advance',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.pendingBadgeRed,
                            ),
                          ),
                          2.hS,
                          Text(
                            item.formattedPendingAdvanceAmount.isNotEmpty
                                ? item.formattedPendingAdvanceAmount
                                : '₹${item.pendingAdvanceAmount}',
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColor.pendingBadgeRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                14.hS,

                // Approve Theme Button
                SizedBox(
                  width: double.infinity,
                  height: 42.h,
                  child: ElevatedButton(
                    onPressed: isApproving ? null : onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      disabledBackgroundColor:
                          AppColor.primary.withValues(alpha: 0.7),
                      foregroundColor: AppColor.pureWhite,
                      elevation: 1,
                      shadowColor: AppColor.primary.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: isApproving
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColor.pureWhite,
                              ),
                            ),
                          )
                        : Text(
                            'Approve',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.pureWhite,
                              letterSpacing: 0.4,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
