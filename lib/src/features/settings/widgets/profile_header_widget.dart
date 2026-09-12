import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/api/api_url.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../profile/bloc/profile_details_bloc/profile_details_bloc.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  String? _resolveImageUrl(String? rawUrl) {
    if (rawUrl == null) return null;
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ProfileDetailsBloc, ProfileDetailsState>(
      builder: (context, state) {
        String name = 'Admin';
        String email = 'admin@navudyojak.com';
        String? profilePhotoUrl;
        final bool isLoading = state is ProfileDetailsLoadingState;

        if (state is ProfileDetailsSuccessState) {
          final profile = state.data.data;
          if (profile != null) {
            if (profile.fullName.trim().isNotEmpty) {
              name = profile.fullName.trim();
            } else if (profile.employee?.fullName.trim().isNotEmpty == true) {
              name = profile.employee!.fullName.trim();
            }

            if (profile.email.trim().isNotEmpty) {
              email = profile.email.trim();
            } else if (profile.employee?.email.trim().isNotEmpty == true) {
              email = profile.employee!.email.trim();
            }

            profilePhotoUrl = profile.profilePhotoUrl;
          }
        }

        final resolvedPhotoUrl = _resolveImageUrl(profilePhotoUrl);

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

              // Profile card — avatar + name + email
              Skeletonizer(
                enabled: isLoading,
                child: Container(
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
                        child: ClipOval(
                          child: resolvedPhotoUrl != null
                              ? Image.network(
                                  resolvedPhotoUrl,
                                  width: 60.r,
                                  height: 60.r,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Center(
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 32.sp,
                                      color: AppColor.cockpitOrange,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.person_rounded,
                                    size: 32.sp,
                                    color: AppColor.cockpitOrange,
                                  ),
                                ),
                        ),
                      ),
                      16.wS,

                      // Name & email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColor.black,
                                letterSpacing: -0.2,
                              ),
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            4.hS,
                            Text(
                              email,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.textSecondary,
                              ),
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
