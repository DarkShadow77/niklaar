import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../styles/text_styles.dart';

Future<dynamic> outerLoadingDialog({
  required String text,
  bool canPop = true,
}) async {
  return Get.dialog(
    name: "outer_loading_dialog",
    barrierDismissible: canPop,
    transitionDuration: const Duration(milliseconds: 800),
    OuterLoadingDialog(
      text: text,
      canPop: canPop,
    ),
  );
}

class OuterLoadingDialog extends StatefulWidget {
  const OuterLoadingDialog({
    super.key,
    required this.text,
    required this.canPop,
  });

  final String text;
  final bool canPop;

  @override
  State<OuterLoadingDialog> createState() => _OuterLoadingDialogState();
}

class _OuterLoadingDialogState extends State<OuterLoadingDialog> {
  bool delay = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        delay = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canPop,
      child: Container(
        color: AppColors.black10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      width: 1.5.r,
                      color: AppColors.black30,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.fallingDot(
                        color: AppColors.primary,
                        size: 32.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Opacity(
              opacity: delay ? 1 : 0,
              child: RichText(
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: widget.text,
                  style: TextStyles.normalMedium14(context)
                      .copyWith(color: AppColors.white75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
