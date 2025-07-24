import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../styles/text_styles.dart';

class SearchTextInput extends StatelessWidget {
  const SearchTextInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.autofocus = false,
    this.errorBool = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.words,
    this.onChanged,
    this.length = 999,
  });

  final bool errorBool;
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          width: 1.w,
          color: errorBool ? AppColors.error : AppColors.grey,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 16.h,
            color: AppColors.blue,
          ),
          SizedBox(
            width: 12.w,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autofocus,
              keyboardType: textInputType,
              textInputAction: textInputAction,
              textCapitalization: textCapitalization,
              inputFormatters: [
                LengthLimitingTextInputFormatter(length),
              ],
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyles.normalRegular14(context).copyWith(
                  fontSize:
                      TextStyles.normalRegular14(context).fontSize! + 2.sp,
                  color: AppColors.black20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 13.5.h),
                constraints: BoxConstraints(
                  minHeight: 0.h,
                  maxHeight: 36.h,
                ),
              ),
              style: TextStyles.normalRegular14(context).copyWith(
                fontSize: TextStyles.normalRegular14(context).fontSize! + 2.sp,
                color: AppColors.black75,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
