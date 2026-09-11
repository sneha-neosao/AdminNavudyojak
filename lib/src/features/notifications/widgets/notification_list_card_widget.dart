import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';
import 'notification_item.dart';

class NotificationListCardWidget extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onTap;

  const NotificationListCardWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  Color _getIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return AppColor.cockpitOrange;
      case NotificationType.alert:
        return AppColor.brightRed;
      case NotificationType.customer:
        return AppColor.metricGreen;
      case NotificationType.system:
        return AppColor.slateGrey;
    }
  }

  Color _getIconBgColor(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return AppColor.avatarBg;
      case NotificationType.alert:
        return AppColor.brightRed.withValues(alpha: 0.1);
      case NotificationType.customer:
        return AppColor.metricGreen.withValues(alpha: 0.1);
      case NotificationType.system:
        return AppColor.metricCardBorder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = _getIconColor(item.type);
    final iconBgColor = _getIconBgColor(item.type);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: item.isRead
              ? AppColor.metricCardBorder
              : AppColor.cockpitOrange.withValues(alpha: 0.35),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: item.isRead ? 0.02 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AppColor.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else {
              AppSnackBarWidget.show(
                context,
                message: item.title,
                type: ToastType.info,
              );
            }
          },
          splashColor: AppColor.orangeTint2.withValues(alpha: 0.5),
          highlightColor: AppColor.orangeTint2.withValues(alpha: 0.3),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Circle
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      size: 20.sp,
                      color: iconColor,
                    ),
                  ),
                ),
                12.wS,

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontSize: 14.sp,
                                fontWeight: item.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w700,
                                color: AppColor.black,
                              ),
                              softWrap: true,
                            ),
                          ),
                          6.wS,
                          Text(
                            item.time,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColor.textSecondary,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                      4.hS,
                      Text(
                        item.message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.textSecondary,
                          height: 1.35,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),

                // Unread Indicator Dot
                if (!item.isRead) ...[
                  8.wS,
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
