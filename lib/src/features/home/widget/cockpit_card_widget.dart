import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../profile/bloc/profile_details_bloc/profile_details_bloc.dart';

class CockpitCardWidget extends StatelessWidget {
  final String? userName;
  final String dateText;
  final String alertText;

  const CockpitCardWidget({
    super.key,
    this.userName,
    this.dateText = 'Tuesday, 24 August 2026',
    this.alertText = '3 urgent alerts',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
      builder: (context, state) {
        String displayName = userName ?? 'Admin';
        final bool isLoading = state is ProfileDetailsLoadingState;

        if (state is ProfileDetailsSuccessState) {
          final profile = state.data.data;
          if (profile != null) {
            if (profile.fullName.trim().isNotEmpty) {
              displayName = profile.fullName.trim();
            } else if (profile.employee?.fullName.trim().isNotEmpty == true) {
              displayName = profile.employee!.fullName.trim();
            }
          }
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: AppColor.cockpitOrange,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.cockpitOrange.withValues(alpha: 0.28),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OWNER COCKPIT',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColor.cockpitSubtitle,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  fontSize: 11.sp,
                ),
                softWrap: true,
              ),
              10.hS,
              Skeletonizer(
                enabled: isLoading,
                child: Text(
                  'Good morning, $displayName',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 23.sp,
                    height: 1.2,
                  ),
                  softWrap: true,
                ),
              ),
          8.hS,
          Text(
            'Your complete business pulse for machine trading operations.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColor.cockpitSubtitle,
              fontSize: 13.5.sp,
              height: 1.35,
              fontWeight: FontWeight.w400,
            ),
            softWrap: true,
          ),
          20.hS,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColor.cockpitPill,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    dateText,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColor.white,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  alertText,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColor.white,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}
