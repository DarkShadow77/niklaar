import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:niklaar/core/constants/app_assets.dart';

class NiklaarIcon extends StatelessWidget {
  const NiklaarIcon({
    super.key,
    this.width = 69.31,
    this.height = 48.99,
    this.opacity = 1,
  });

  final double width;
  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 1.0 - opacity.clamp(0.0, 1.0),
              child: SvgPicture.asset(
                AssetsLogo.logo,
                fit: BoxFit.contain,
                width: width.w,
                height: height.h,
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: SvgPicture.asset(
                AssetsLogo.lightLogo,
                fit: BoxFit.contain,
                width: width.w,
                height: height.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
