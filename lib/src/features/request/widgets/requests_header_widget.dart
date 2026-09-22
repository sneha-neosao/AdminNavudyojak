import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

class RequestsHeaderWidget extends StatelessWidget {
  final int selectedTab;

  const RequestsHeaderWidget({
    super.key,
    this.selectedTab = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final subtitle =
        selectedTab == 0 ? 'FINAL APPROVAL QUEUE' : 'ADVANCE BOOKINGS QUEUE';
    final title =
        selectedTab == 0 ? 'Refund Requests' : 'Sales & Booking Management';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.cockpitOrange,
              letterSpacing: 1.2,
            ),
            softWrap: true,
          ),
          4.hS,
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: AppColor.black,
              letterSpacing: -0.3,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
