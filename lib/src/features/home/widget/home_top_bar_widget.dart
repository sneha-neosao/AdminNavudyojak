import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_color.dart';
import '../../../routes/app_route_path.dart';

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
              onTap: () {
                context.pushNamed(AppRoute.notifications.name);
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: AppColor.charcoal,
                      size: 22.sp,
                    ),
                    Positioned(
                      top: 9.h,
                      right: 10.w,
                      child: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const BoxDecoration(
                          color: AppColor.cockpitOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
