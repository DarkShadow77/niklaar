import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../styles/text_styles.dart';

class InputTitle extends StatelessWidget {
  const InputTitle({
    super.key,
    required this.text,
    this.child,
  });

  final String text;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: 20.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: text,
                style: TextStyles.smallRegular12(context),
              ),
            ),
            if (child != null) child!,
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
      ],
    );
  }
}
