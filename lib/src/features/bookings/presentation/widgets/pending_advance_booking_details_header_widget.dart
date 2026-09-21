import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class PendingAdvanceBookingDetailsHeaderWidget extends StatelessWidget {
  final String title;

  const PendingAdvanceBookingDetailsHeaderWidget({
    super.key,
    this.title = 'Booking Details',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 40.w),
            child: Text(
              'BOOKING DETAILS',
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.cockpitOrange,
                letterSpacing: 1.2,
              ),
              softWrap: true,
            ),
          ),
          2.hS,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/pending-advance-bookings');
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(4.r),
                  child: Icon(
                    Icons.arrow_back,
                    size: 24.sp,
                    color: AppColor.black,
                  ),
                ),
              ),
              8.wS,
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.charcoal,
                    letterSpacing: -0.5,
                  ),
                  softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
