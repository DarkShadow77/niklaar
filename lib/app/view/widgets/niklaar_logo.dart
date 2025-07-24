import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import 'niklaar_icon.dart';

class NiklaarLogo extends StatelessWidget {
  const NiklaarLogo({
    super.key,
    this.opacity = 1,
    this.iconOpacity = 0,
    this.logoW = 69.31,
    this.logoH = 48.99,
    this.textH = 40,
    this.whithen = false,
  });

  final double opacity;
  final double iconOpacity;
  final double logoW;
  final double logoH;
  final double textH;
  final bool whithen;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Opacity(
          opacity: iconOpacity,
          child: NiklaarIcon(
            width: logoW,
            height: logoH,
          ),
        ),
        Opacity(
          opacity: opacity,
          child: SvgPicture.asset(
            AssetsLogo.name,
            fit: BoxFit.contain,
            height: textH.h,
            colorFilter: ColorFilter.mode(
              whithen ? AppColors.white : AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
        )
      ],
    );
  }
}
