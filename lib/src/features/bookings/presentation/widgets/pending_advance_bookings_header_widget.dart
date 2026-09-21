import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../../core/theme/app_color.dart';

class PendingAdvanceBookingsHeaderWidget extends StatelessWidget {
  final int count;

  const PendingAdvanceBookingsHeaderWidget({
    super.key,
    this.count = 0,
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
              'ADMIN BOOKINGS',
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
                    context.go('/home');
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
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Pending Advances',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.charcoal,
                          letterSpacing: -0.5,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (count > 0) ...[
                      8.wS,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColor.pendingBadgeRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color:
                                AppColor.pendingBadgeRed.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            color: AppColor.pendingBadgeRed,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
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
}
