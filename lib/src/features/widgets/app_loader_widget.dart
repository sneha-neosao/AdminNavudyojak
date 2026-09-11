import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';

class AppLoaderWidget extends StatelessWidget {
  final Color? color;
  final double? radius;

  const AppLoaderWidget({super.key, this.color, this.radius});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: color ?? AppColors.brandPurple,
      radius: radius ?? 10.r,
    );
  }
}
