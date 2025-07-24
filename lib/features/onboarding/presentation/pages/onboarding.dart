import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:niklaar/core/constants/navigators/routeName.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/strings.dart';
import 'onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPage = 0;

  bool end = false;

  final PageController _pageController = PageController(
    initialPage: 0,
  );

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 8), (Timer timer) {
      if (_currentPage < Lists.onBoardingData.length - 1) {
        _currentPage++;
      } else {
        _timer.cancel();
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    end = _currentPage == Lists.onBoardingData.length - 1;
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: 14.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (end) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteName.landingPage,
                                  (route) => false,
                              );
                            } else {
                              _currentPage = Lists.onBoardingData.length - 1;

                              _pageController.animateToPage(
                                _currentPage,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                end ? AppColors.white50 : Colors.transparent,
                            overlayColor: AppColors.white50,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                            ),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: end ? "Get Started" : "SKIP",
                              style:
                                  TextStyles.normalRegular14(context).copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      allowImplicitScrolling: true,
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (value) {
                        setState(() {
                          _currentPage = value;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: Lists.onBoardingData.length,
                      itemBuilder: (_, index) {
                        return OnboardingContent(
                          images:
                              Lists.onBoardingData[index]["image"].toString(),
                          subtitle: Lists.onBoardingData[index]["subtitle"]
                              .toString(),
                          title:
                              Lists.onBoardingData[index]["title"].toString(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 120.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  Lists.onBoardingData.length,
                  (indexDots) {
                    return AnimatedContainer(
                      margin: EdgeInsets.only(right: 6.w),
                      width: _currentPage == indexDots ? 19.w : 7.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: _currentPage == indexDots
                            ? AppColors.primary
                            : AppColors.lightBlue,
                      ),
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
