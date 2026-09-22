import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

class RequestsTabBarWidget extends StatelessWidget {
  final TabController tabController;
  final int requestsCount;
  final int bookingsCount;
  final ValueChanged<int>? onTabSelected;

  const RequestsTabBarWidget({
    super.key,
    required this.tabController,
    this.requestsCount = 0,
    this.bookingsCount = 0,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final animation = tabController.animation ?? tabController;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColor.orangeTint2.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColor.border.withValues(alpha: 0.6),
            width: 1.2,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final pillWidth = availableWidth / 2;

            return AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final animValue = tabController.animation?.value ??
                    tabController.index.toDouble();
                final clampedValue = animValue.clamp(0.0, 1.0);
                final pillLeft = clampedValue * pillWidth;

                // Color interpolation factors
                final t0 = (1.0 - clampedValue).clamp(0.0, 1.0);
                final t1 = clampedValue;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Smooth sliding pill background
                    Positioned(
                      left: pillLeft,
                      top: 0,
                      bottom: 0,
                      width: pillWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primary.withValues(alpha: 0.28),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Interactive Tab Labels
                    Row(
                      children: [
                        // Tab 0: Requests
                        Expanded(
                          child: _buildTabItem(
                            theme: theme,
                            index: 0,
                            icon: Icons.assignment_outlined,
                            label: 'Requests',
                            count: requestsCount,
                            selectionWeight: t0,
                          ),
                        ),
                        // Tab 1: Bookings
                        Expanded(
                          child: _buildTabItem(
                            theme: theme,
                            index: 1,
                            icon: Icons.calendar_month_outlined,
                            label: 'Bookings',
                            count: bookingsCount,
                            selectionWeight: t1,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required ThemeData theme,
    required int index,
    required IconData icon,
    required String label,
    required int count,
    required double selectionWeight,
  }) {
    final iconColor = Color.lerp(
      AppColor.charcoal,
      AppColor.pureWhite,
      selectionWeight,
    )!;

    final textColor = Color.lerp(
      AppColor.charcoal,
      AppColor.pureWhite,
      selectionWeight,
    )!;

    final badgeBg = Color.lerp(
      AppColor.primary.withValues(alpha: 0.12),
      AppColor.pureWhite.withValues(alpha: 0.25),
      selectionWeight,
    )!;

    final badgeTextColor = Color.lerp(
      AppColor.primary,
      AppColor.pureWhite,
      selectionWeight,
    )!;

    final isSelected = selectionWeight > 0.5;

    return Material(
      color: AppColor.transparent,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: () {
          tabController.animateTo(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
          );
          onTabSelected?.call(index);
        },
        splashColor: AppColor.transparent,
        highlightColor: AppColor.transparent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: iconColor,
              ),
              6.wS,
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: textColor,
                    letterSpacing: -0.1,
                  ),
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (count > 0) ...[
                6.wS,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: badgeTextColor,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
