import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OWNER PROFILE',
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
            'Profile',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: AppColor.black,
              letterSpacing: -0.3,
            ),
            softWrap: true,
          ),
          20.hS,

          // Profile card — avatar + name + role
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
            child: Row(
              children: [
                // Avatar circle
                Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    color: AppColor.avatarBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.cockpitOrange.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 32.sp,
                      color: AppColor.cockpitOrange,
                    ),
                  ),
                ),
                16.wS,

                // Name & role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Atharva',
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
                        'Business Owner',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.textSecondary,
                        ),
                        softWrap: true,
                      ),
                    ],
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
