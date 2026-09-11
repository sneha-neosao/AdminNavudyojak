import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

class NotificationsFilterChipsWidget extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback? onMarkAllRead;
  final int unreadCount;
  final bool isLoading;

  const NotificationsFilterChipsWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.onMarkAllRead,
    this.unreadCount = 0,
    this.isLoading = false,
  });

  static const List<String> filters = [
    'All',
    'Unread',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Filter Chips: Only 'All' and 'Unread'
          ...filters.map((filter) {
            final isSelected = filter == selectedFilter;

            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Material(
                color: AppColor.transparent,
                borderRadius: BorderRadius.circular(20.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () => onFilterChanged(filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.cockpitOrange
                          : AppColor.pureWhite,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.cockpitOrange
                            : AppColor.metricCardBorder,
                        width: 1.1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColor.cockpitOrange
                                    .withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 12.5.sp,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColor.pureWhite
                              : AppColor.charcoal,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // Mark all read button on the same line at the rightmost
          TextButton(
            onPressed: isLoading ? null : onMarkAllRead,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppColor.primary,
              disabledForegroundColor: AppColor.gray,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  Padding(
                    padding: EdgeInsets.only(right: 6.w),
                    child: SizedBox(
                      width: 12.r,
                      height: 12.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primary,
                      ),
                    ),
                  )
                else ...[
                  Icon(
                    Icons.done_all_rounded,
                    size: 16.sp,
                    color: onMarkAllRead != null
                        ? AppColor.primary
                        : AppColor.gray,
                  ),
                  4.wS,
                ],
                Text(
                  'Mark all read',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    color: (onMarkAllRead != null && !isLoading)
                        ? AppColor.primary
                        : AppColor.gray,
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
