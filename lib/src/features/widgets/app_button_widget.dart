import 'package:admin_navudyojak/src/features/widgets/app_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

class AppButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final Color? accentColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? textColor;
  final Color? iconColor;
  final double? fontSize;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BorderSide? borderSide;
  final double? iconSize;
  final bool showShadow;
  final Color? shadowColor;

  const AppButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.accentColor,
    this.icon,
    this.width,
    this.height,
    this.textColor,
    this.iconColor,
    this.fontSize,
    this.borderRadius,
    this.padding,
    this.borderSide,
    this.iconSize,
    this.showShadow = true,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color buttonColor = isLoading
        ? (accentColor ?? AppColors.brandOrage).withValues(alpha: 0.6)
        : (onPressed == null
        ? (isDark ? Colors.white12 : Colors.black12)
        : (accentColor ?? AppColors.brandOrage));

    final bool shouldShowShadow = onPressed != null &&
        !isLoading &&
        showShadow &&
        accentColor != Colors.transparent;

    return SizedBox(
      width: width,
      height: height ?? 40.h,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
          border: borderSide != null
              ? Border.fromBorderSide(borderSide!)
              : null,
          boxShadow: shouldShowShadow
              ? [
            BoxShadow(
              color: (shadowColor ?? accentColor ?? AppColors.brandOrage)
                  .withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
            splashColor: Colors.white.withValues(alpha: 0.12),
            highlightColor: Colors.white.withValues(alpha: 0.06),
            child: Padding(
              padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w),
              child: Center(
                child: isLoading
                    ? const AppLoaderWidget(
                  color: Colors.white,
                  radius: 8,
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: iconColor ?? textColor ?? Colors.white,
                        size: iconSize ?? 18.r,
                      ),
                      SizedBox(width: 6.w),
                    ],
                    Flexible(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor ?? Colors.white,
                          fontSize: fontSize ?? 13.sp,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
