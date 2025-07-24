import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.images,
    required this.subtitle,
    required this.title,
  });

  final String images;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 54.h,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: title,
                style: TextStyles.h2ExtraBold32(context).copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: subtitle,
                style: TextStyles.bodyRegular16(context).copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: FadeInImage(
            image: AssetImage(
              images,
            ),
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
            placeholder: const AssetImage(""),
            fadeInCurve: Curves.easeInOut,
            fadeInDuration: const Duration(seconds: 2),
          ),
        ),
      ],
    );
  }
}
