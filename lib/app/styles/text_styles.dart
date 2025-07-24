import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FontSizes {
  static final smallCard = 8.0.sp;
  static final card = 10.0.sp;
  static final small = 12.0.sp;
  static final normal = 14.0.sp;
  static final body = 16.0.sp;
  static final title = 20.0.sp;
  static final heading2 = 32.0.sp;
  static final heading1 = 40.0.sp;
}

class TextStyles {
  static TextStyle smallCardRegular8(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: FontSizes.smallCard,
        );
  }

  static TextStyle smallCardMedium8(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: FontSizes.smallCard,
        );
  }

  static TextStyle smallCardSemibold8(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: FontSizes.smallCard,
        );
  }

  static TextStyle smallCardBold8(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: FontSizes.smallCard,
        );
  }

  static TextStyle cardRegular10(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: FontSizes.card,
        );
  }

  static TextStyle cardMedium10(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: FontSizes.card,
        );
  }

  static TextStyle cardSemibold10(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: FontSizes.card,
        );
  }

  static TextStyle cardBold10(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: FontSizes.card,
        );
  }

  static TextStyle smallRegular12(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: FontSizes.small,
        );
  }

  static TextStyle smallMedium12(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: FontSizes.small,
        );
  }

  static TextStyle smallSemibold12(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: FontSizes.small,
        );
  }

  static TextStyle smallBold12(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: FontSizes.small,
        );
  }

  static TextStyle normalRegular14(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: FontSizes.normal,
        );
  }

  static TextStyle normalMedium14(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: FontSizes.normal,
        );
  }

  static TextStyle normalSemibold14(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: FontSizes.normal,
        );
  }

  static TextStyle normalBold14(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: FontSizes.normal,
        );
  }

  static TextStyle bodyRegular16(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: FontSizes.body,
        );
  }

  static TextStyle bodyMedium16(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: FontSizes.body,
        );
  }

  static TextStyle bodySemiBold16(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: FontSizes.body,
        );
  }

  static TextStyle bodyBold16(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: FontSizes.body,
        );
  }

  static TextStyle titleRegular20(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: FontSizes.title,
        );
  }

  static TextStyle titleMedium20(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: FontSizes.title,
        );
  }

  static TextStyle titleSemiBold20(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: FontSizes.title,
        );
  }

  static TextStyle titleBold20(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: FontSizes.title,
        );
  }

  static TextStyle h2Regular32(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: FontSizes.heading2,
        );
  }

  static TextStyle h2Medium32(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: FontSizes.heading2,
        );
  }

  static TextStyle h2SemiBold32(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: FontSizes.heading2,
        );
  }

  static TextStyle h2Bold32(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: FontSizes.heading2,
        );
  }

  static TextStyle h2ExtraBold32(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: FontSizes.heading2,
        );
  }

  static TextStyle h1Regular40(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: FontSizes.heading1,
        );
  }

  static TextStyle h1Medium40(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: FontSizes.heading1,
        );
  }

  static TextStyle h1SemiBold40(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: FontSizes.heading1,
        );
  }

  static TextStyle h1Bold40(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: FontSizes.heading1,
        );
  }
}
