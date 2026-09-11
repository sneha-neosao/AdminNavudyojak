import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

class CustomerDetailsHeaderWidget extends StatelessWidget {
  const CustomerDetailsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button
          InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/customers');
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
          12.wS,

          // Header Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CUSTOMER INTELLIGENCE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.cockpitOrange,
                    letterSpacing: 1.2,
                  ),
                  softWrap: true,
                ),
                2.hS,
                Text(
                  'Customers',
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
          ),
        ],
      ),
    );
  }
}
