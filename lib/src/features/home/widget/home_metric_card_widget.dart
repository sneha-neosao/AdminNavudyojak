import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';
import 'home_metric_item.dart';

class HomeMetricCardWidget extends StatelessWidget {
  final HomeMetricItem item;
  final VoidCallback? onTap;

  const HomeMetricCardWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColor.card,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        splashColor: AppColor.orangeTint2.withValues(alpha: 0.5),
        highlightColor: AppColor.orangeTint2.withValues(alpha: 0.3),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColor.metricCardBorder,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 20.sp,
                color: AppColor.cockpitOrange,
              ),
              8.hS,
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  item.value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.black,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  softWrap: true,
                ),
              ),
              3.hS,
              Text(
                item.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textSecondary,
                ),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              6.hS,
              Text(
                item.subtext,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.metricGreen,
                ),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
