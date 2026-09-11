import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import '../../widgets/app_snackbar_widget.dart';
import 'setting_item_data.dart';

class AlertPreferencesCardWidget extends StatelessWidget {
  const AlertPreferencesCardWidget({super.key});

  static const List<SettingItemData> _items = [
    SettingItemData(
      title: 'Critical finance alerts',
      subtitle: 'Payment overdue, margin exceptions',
      icon: Icons.notifications_none_rounded,
    ),
    SettingItemData(
      title: 'Approval guardrails',
      subtitle: 'Credit and buyback limits',
      icon: Icons.shield_outlined,
    ),
    SettingItemData(
      title: 'Daily summary',
      subtitle: '8:00 AM owner pulse',
      icon: Icons.tune_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Alert preferences',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
              letterSpacing: -0.2,
            ),
            softWrap: true,
          ),
          4.hS,

          // Subtitle
          Text(
            'Choose what reaches Atharva immediately.',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
            ),
            softWrap: true,
          ),
          18.hS,

          // Preference Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (context, index) => 12.hS,
            itemBuilder: (context, index) {
              final item = _items[index];
              return _buildSettingTile(context, theme, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    ThemeData theme,
    SettingItemData item,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.metricCardBorder,
          width: 1.1,
        ),
      ),
      child: Material(
        color: AppColor.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            if (item.onTap != null) {
              item.onTap!();
            } else {
              AppSnackBarWidget.show(
                context,
                message: '${item.title} selected',
                type: ToastType.info,
              );
            }
          },
          splashColor: AppColor.orangeTint2.withValues(alpha: 0.5),
          highlightColor: AppColor.orangeTint2.withValues(alpha: 0.3),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                // Leading Icon in Orange
                Icon(
                  item.icon,
                  size: 22.sp,
                  color: AppColor.cockpitOrange,
                ),
                14.wS,

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                        ),
                        softWrap: true,
                      ),
                      4.hS,
                      Text(
                        item.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.textSecondary,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),

                // Trailing Arrow
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.sp,
                  color: AppColor.slateGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
