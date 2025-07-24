import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:niklaar/app/view/widgets/button/action_button.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/navigators/routeName.dart';

class AccountCreatedPage extends StatefulWidget {
  const AccountCreatedPage({super.key});

  @override
  State<AccountCreatedPage> createState() => _AccountCreatedPageState();
}

class _AccountCreatedPageState extends State<AccountCreatedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 94.h,
            ),
            Icon(
              Icons.check_circle_rounded,
              size: 44.sp,
              color: AppColors.blue,
              weight: 500,
              grade: 200,
            ),
            SizedBox(
              height: 24.h,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Account Created",
                style: TextStyles.titleSemiBold20(context),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    "Congratulations! Your Niklaar account has\nsuccessfully been created.",
                style: TextStyles.normalRegular14(context),
              ),
            ),
            SizedBox(
              height: 24.h,
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteName.landingPage,
                    (route) => false,
                  );
                },
                text: "Go to Home",
              ),
            ),
            SizedBox(
              height: 45 + MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }
}
