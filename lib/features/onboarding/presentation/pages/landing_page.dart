import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:niklaar/app/view/widgets/niklaar_logo.dart';
import 'package:niklaar/core/constants/app_assets.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/button/action_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/navigators/routeName.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // 0% at top
            end: Alignment.bottomCenter, // 100% at bottom
            colors: [
              AppColors.blue94,
              AppColors.primary,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.bottom,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: FadeInImage(
                  image: AssetImage(
                    AssetsOnboarding.onboardingImage4,
                  ),
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  placeholder: const AssetImage(""),
                  fadeInCurve: Curves.easeInOut,
                  fadeInDuration: const Duration(seconds: 2),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 55.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 45.h,
                    ),
                    NiklaarLogo(
                      logoW: 54.4,
                      logoH: 39,
                      textH: 30.9,
                      iconOpacity: 1,
                      whithen: true,
                    ).fadeInUp(),
                    Spacer(),
                    ActionButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          RouteName.selectCountryPage,
                        );
                      },
                      text: "Create an account",
                      color: AppColors.white,
                      textColor: AppColors.primary,
                    ).elasticIn(delay: Duration(milliseconds: 300)),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        overlayColor: AppColors.white50,
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Sign In",
                          style: TextStyles.bodyBold16(context).copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ).elasticIn(delay: Duration(milliseconds: 500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
