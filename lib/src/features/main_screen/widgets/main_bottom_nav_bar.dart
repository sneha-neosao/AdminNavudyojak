import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/extensions/integer_sizedbox_extension.dart';
import '../../../core/theme/app_color.dart';

class BottomNavItemData {
  final String label;
  final IconData icon;

  const BottomNavItemData({
    required this.label,
    required this.icon,
  });
}

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<BottomNavItemData> _items = [
    BottomNavItemData(
      label: 'Home',
      icon: Icons.home_outlined,
    ),
    BottomNavItemData(
      label: 'Analytics',
      icon: Icons.bar_chart_rounded,
    ),
    BottomNavItemData(
      label: 'Customers',
      icon: Icons.people_outline_rounded,
    ),
    BottomNavItemData(
      label: 'Requests',
      icon: Icons.assignment_outlined,
    ),
    BottomNavItemData(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColor.card,
        border: Border(
          top: BorderSide(
            color: AppColor.border.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.h,
            horizontal: 6.w,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabWidth = constraints.maxWidth / _items.length;
              
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
                    left: tabWidth * currentIndex,
                    width: tabWidth,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        width: tabWidth,
                        decoration: BoxDecoration(
                          color: AppColor.orangeTint2,
                          border: Border.all(
                            color: AppColor.border,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_items.length, (index) {
                      final item = _items[index];
                      final isSelected = index == currentIndex;

                      return Expanded(
                        child: InkWell(
                          onTap: () => onTap(index),
                          splashColor: AppColor.transparent,
                          highlightColor: AppColor.transparent,
                          child: Center(
                            heightFactor: 1.0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    item.icon,
                                    size: 22.sp,
                                    color: isSelected
                                        ? AppColor.primary
                                        : AppColor.charcoal,
                                  ),
                                  3.hS,
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 250),
                                    style: theme.textTheme.labelSmall!.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppColor.primary
                                          : AppColor.charcoal,
                                      letterSpacing: -0.1,
                                    ),
                                    child: Text(
                                      item.label,
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
