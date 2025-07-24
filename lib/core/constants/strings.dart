import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_assets.dart';

class Strings {
  static const appName = 'Niklaar';
  static const appFailure = 'An unknown error occurred';
  static const noInternet =
      'Please check your internet connection and try again';
  static const unknown = 'Something went wrong. Try again.';
}

class AppSize {
  static double width = 430.w;
  static double height = 932.h;
}

class Lists {
  static List<Map<String, String>> onBoardingData = [
    {
      "image": AssetsOnboarding.onboardingImage1,
      "title": "Borderless Payments,\nInstant Transfers",
      "subtitle":
          "Enjoy seamless money transfers and hassle-free\ntransactions.",
    },
    {
      "image": AssetsOnboarding.onboardingImage2,
      "title": "Discover & Share\nthe Best Deals",
      "subtitle": "Explore amazing deals or share your own\nwith the community",
    },
    {
      "image": AssetsOnboarding.onboardingImage3,
      "title": "Unlock Exclusive\nDiscounts",
      "subtitle":
          "Get more visibility and increase sales by listing\non influencer pages on the discount markert",
    },
    {
      "image": AssetsOnboarding.onboardingImage4,
      "title": "Build & Track Your\nCredit Score",
      "subtitle":
          "Stay credible and trustworthy by shopping,\nreviewing, and engaging with deals.",
    }
  ];
}
