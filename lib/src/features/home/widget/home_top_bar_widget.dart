import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/theme/app_color.dart';
import '../../../routes/app_route_path.dart';
import '../../notifications/bloc/notifications_count_bloc/notifications_count_bloc.dart';

class HomeTopBarWidget extends StatelessWidget {
  const HomeTopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Admin Dashboard',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColor.charcoal,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Material(
            color: AppColor.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22.r),
              onTap: () async {
                await context.pushNamed(AppRoute.notifications.name);
                if (context.mounted) {
                  context
                      .read<NotificationsCountBloc>()
                      .add(const RefreshNotificationsCountEvent());
                }
              },
              child: Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColor.card,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.metricCardBorder,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: BlocBuilder<NotificationsCountBloc,
                    NotificationsCountState>(
                  builder: (context, state) {
                    final isLoading = state is NotificationsCountLoadingState;
                    int unreadCount = 0;
                    if (state is NotificationsCountSuccessState) {
                      unreadCount = state.data.data?.unreadCount ?? 0;
                    }

                    Widget? badgeWidget;
                    if (isLoading) {
                      badgeWidget = Skeletonizer(
                        enabled: true,
                        child: Container(
                          width: 16.r,
                          height: 16.r,
                          decoration: const BoxDecoration(
                            color: AppColor.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    } else if (unreadCount > 0) {
                      final countText =
                          unreadCount > 99 ? '99+' : '$unreadCount';
                      badgeWidget = Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: unreadCount > 9 ? 3.w : 2.w,
                          vertical: 1.h,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 17.r,
                          minHeight: 17.r,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.pureWhite,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            countText,
                            style: TextStyle(
                              color: AppColor.pureWhite,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          color: AppColor.charcoal,
                          size: 22.sp,
                        ),
                        if (badgeWidget != null)
                          Positioned(
                            top: 4.h,
                            right: 4.w,
                            child: badgeWidget,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
