import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../styles/text_styles.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onPressed,
    this.waitOnPressed,
    required this.text,
    this.loading = false,
    this.waiting = true,
    this.color,
    this.textColor,
  });

  final VoidCallback onPressed;
  final VoidCallback? waitOnPressed;
  final String text;
  final bool loading;
  final bool waiting;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    Color nullColor = color ?? AppColors.primary;
    return Material(
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: loading
            ? () {}
            : !waiting
                ? waitOnPressed ?? () {}
                : onPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          height: 51.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 10.w,
          ),
          decoration: BoxDecoration(
            color: loading
                ? nullColor.withOpacity(.8)
                : !waiting
                    ? nullColor.withOpacity(.5)
                    : nullColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*if (loading) ...[
                LoadingAnimationWidget.beat(
                  color: AppColors.white,
                  size: 16.sp,
                ),
                SizedBox(
                  width: 12.w,
                ),
              ],*/
              RichText(
                text: TextSpan(
                  text: text,
                  style: TextStyles.bodySemiBold16(context).copyWith(
                    color: textColor ?? AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
