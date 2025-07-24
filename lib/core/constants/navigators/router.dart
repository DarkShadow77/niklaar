import 'package:flutter/material.dart';
import 'package:niklaar/features/auth/presentation/pages/select_country_page.dart';

import '../../../features/auth/presentation/pages/account_created_page.dart';
import '../../../features/auth/presentation/pages/create_account_page.dart';
import '../../../features/onboarding/presentation/pages/landing_page.dart';
import '../../../features/onboarding/presentation/pages/onboarding.dart';
import '../../../features/onboarding/presentation/pages/splash_screen_page.dart';
import 'routeName.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteName.splashPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const SplashScreenPage(),
      );
    case RouteName.onboardingPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const OnboardingPage(),
      );
    case RouteName.landingPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const LandingPage(),
      );
    case RouteName.selectCountryPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const SelectCountryPage(),
      );
    case RouteName.accountCreatedPage:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const AccountCreatedPage(),
      );
    case RouteName.createAccountPage:
      final args = settings.arguments! as CreateAccountPageParam;
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: CreateAccountPage(
          params: args,
        ),
      );
    /*case RouteName.authPage:
      final args = settings.arguments! as AuthenticationPageParams;
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: AuthenticationPage(
          params: args,
        ),
      );*/

    default:
      return MaterialPageRoute<dynamic>(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

Route<dynamic> _getPageRoute({
  required String routeName,
  required Widget viewToShow,
}) {
  return MaterialPageRoute(
    settings: RouteSettings(
      name: routeName,
    ),
    builder: (_) => viewToShow,
  );
}
