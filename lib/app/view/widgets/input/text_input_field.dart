import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../styles/text_styles.dart';

class TextInputField extends StatefulWidget {
  const TextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.errorBool = false,
    this.enabled = true,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.length = 999,
    this.border = 1,
    this.textCapitalization = TextCapitalization.none,
    this.prefix,
    this.icon,
    this.color = Colors.transparent,
    this.hintColor,
    this.inputFormatters,
    this.validator,
    this.autoValidateMode,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool errorBool;
  final bool enabled;
  final int length;
  final int border;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final Widget? prefix;
  final Widget? icon;
  final Color color;
  final Color? hintColor;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final AutovalidateMode? autoValidateMode;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool hidePassword = true;
  late FocusNode _focusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: widget.enabled ? widget.color : Colors.transparent,
        border: Border.all(
          width: widget.border.w,
          color: widget.errorBool
              ? AppColors.error
              : isFocused
                  ? AppColors.primary50
                  : AppColors.grey,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            SizedBox(
              width: 10.w,
            ),
          ],
          Expanded(
            child: TextFormField(
              focusNode: _focusNode,
              controller: widget.controller,
              enabled: widget.enabled,
              obscureText: widget.isPassword ? hidePassword : false,
              keyboardType: widget.textInputType,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              autovalidateMode: widget.autoValidateMode,
              validator: widget.validator,
              inputFormatters: [
                if (widget.inputFormatters != null) ...widget.inputFormatters!,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyles.normalRegular14(context).copyWith(
                  fontSize:
                      TextStyles.normalRegular14(context).fontSize! + 2.sp,
                  color: widget.hintColor ?? AppColors.black20,
                ),
                border: InputBorder.none,
              ),
              style: TextStyles.normalRegular14(context).copyWith(
                fontSize: TextStyles.normalRegular14(context).fontSize! + 2.sp,
                color: widget.enabled ? AppColors.black : AppColors.black50,
              ),
              onChanged: widget.onChanged,
            ),
          ),
          widget.prefix ??
              (widget.isPassword
                  ? GestureDetector(
                      onTap: () => setState(() => hidePassword = !hidePassword),
                      child: Icon(
                        hidePassword
                            ? Ionicons.eye_off_outline
                            : Ionicons.eye_outline,
                        size: 16.sp,
                        color: AppColors.black30,
                      ),
                    )
                  : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
