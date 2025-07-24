import 'package:country_state_city/models/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:niklaar/core/constants/navigators/routeName.dart';
import 'package:niklaar/features/auth/data/models/step_one_request_model.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/button/action_button.dart';
import '../../../../app/view/widgets/input/input_title.dart';
import '../../../../app/view/widgets/input/text_input_field.dart';
import '../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../app/view/widgets/niklaar_icon.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/step_two_request_model.dart';
import '../manager/auth_bloc.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({
    super.key,
    required this.params,
  });

  final CreateAccountPageParam params;

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  int currentStep = 0;

  // form field controllers...
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _refCodeCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _isFirstNameValid = false;
  bool _isLastNameValid = false;
  bool _isEmailValid = false;
  bool _isPhoneValid = false;
  bool _isUserValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _isFormValid = true;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _userCtrl.dispose();
    _refCodeCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _validateForm() {
    String firstName = _firstNameCtrl.text.trim();
    String lastName = _lastNameCtrl.text.trim();
    String email = _emailCtrl.text.trim();
    String phone = _phoneCtrl.text.trim();
    String username = _userCtrl.text.trim();
    String password = _passwordCtrl.text.trim();
    String confirmPassword = _confirmCtrl.text.trim();

    setState(() {
      if (currentStep == 0) {
        _isFirstNameValid = firstName.isNotEmpty;
        _isLastNameValid = lastName.isNotEmpty;
        _isEmailValid = GetUtils.isEmail(email);
        _isPhoneValid = GetUtils.isPhoneNumber(phone);
      } else if (currentStep == 1) {
        _isUserValid = username.isNotEmpty;
      } else {
        _isPasswordValid = password.length >= 8;
        _isConfirmPasswordValid = password == confirmPassword;
      }
    });
  }

  bool _formValidation() {
    if (currentStep == 0) {
      return _isFirstNameValid &&
          _isLastNameValid &&
          _isEmailValid &&
          _isPhoneValid;
    } else if (currentStep == 1) {
      return _isUserValid;
    } else {
      return _isPasswordValid && _isConfirmPasswordValid;
    }
  }

  void _nextStep() {
    _validateForm();
    _isFormValid = _formValidation();

    if (!_isFormValid) {
      Get.snackbar(
        "Error",
        "Please fill all required fields correctly.",
        backgroundColor: AppColors.error50,
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    if (currentStep == 0) {
      String code = widget.params.country.phoneCode;
      BlocProvider.of<AuthBloc>(context).add(
        RegisterStepOneEvent(
          request: StepOneRequestModel(
            firstName: _firstNameCtrl.text.trim(),
            lastName: _lastNameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phoneNumber: code + _phoneCtrl.text.trim(),
          ),
        ),
      );
    } else if (currentStep < 2) {
      setState(() => currentStep++);
    } else {
      BlocProvider.of<AuthBloc>(context).add(
        RegisterStepTwoEvent(
          request: StepTwoRequestModel(
            username: _userCtrl.text.trim(),
            referral: _refCodeCtrl.text.trim(),
            password: _passwordCtrl.text.trim(),
            passwordConfirmation: _confirmCtrl.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepTitles = ['Basic Info', 'Username', 'Password'];
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          outerLoadingDialog(
            text: "Registering\nPlease Wait",
            canPop: false,
          );
        }
        if (state is AuthSuccessState) {
          Get.back();
          if (state.authType == AuthType.registerStepOne) {
            setState(() => currentStep++);
          }
          if (state.authType == AuthType.registerStepTwo) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RouteName.accountCreatedPage,
              (route) => false,
            );
            Get.snackbar(
              "Success",
              state.message,
              backgroundColor: AppColors.success5,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
            );
          }
        }
        if (state is AuthFailureState) {
          Get.back();
          Get.snackbar(
            "Error",
            state.message,
            backgroundColor: AppColors.error50,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Opacity(
              opacity: currentStep == 2 ? 0 : 1,
              child: NiklaarIcon(
                width: 39.6,
                height: 28,
                opacity: 0,
              ),
            ),
            automaticallyImplyLeading: true,
            titleSpacing: 24.w,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                child: Row(
                  children: [
                    if (currentStep == 2)
                      NiklaarIcon(
                        width: 39.6,
                        height: 28,
                        opacity: 0,
                      )
                    else
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          overlayColor: AppColors.black25,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                          ),
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Sign In",
                            style: TextStyles.normalRegular14(context).copyWith(
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Let’s get you started",
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
                        "Enter your details and create a password\nto set up your account",
                    style: TextStyles.normalRegular14(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 24.h,
                  ),
                  child: Row(
                    spacing: 9.5.w,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(stepTitles.length, (i) {
                      final done = i < currentStep;
                      final active = i == currentStep;
                      return _buildStepper(
                          done, active, i, stepTitles, context);
                    }),
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: currentStep,
                    children: [
                      _buildBasicInfoForm(),
                      _buildUsernameForm(),
                      _buildPasswordForm(),
                    ],
                  ),
                ),
                ActionButton(
                  onPressed: _nextStep,
                  waiting: _formValidation(),
                  waitOnPressed: _nextStep,
                  text: currentStep < 2 ? 'Continue' : 'Create account',
                ),
                SizedBox(
                  height: 45 + MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Expanded _buildStepper(bool done, bool active, int i, List<String> stepTitles,
      BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: done || active ? AppColors.black : AppColors.white,
          fixedSize: Size(100.w, 31.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
            side: BorderSide(
              color: done || active ? AppColors.black : AppColors.grey,
              width: 1.w,
            ),
          ),
          elevation: 0,
        ),
        onPressed:
            i <= currentStep ? () => setState(() => currentStep = i) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: stepTitles[i],
                style: TextStyles.smallRegular12(context).copyWith(
                  color: done || active ? AppColors.white : AppColors.black20,
                ),
              ),
            ),
            if (done)
              Icon(
                Icons.check,
                color: AppColors.blue,
                size: 12.sp,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoForm() {
    return Form(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: [
          InputTitle(
            text: "First Name",
          ),
          TextInputField(
            controller: _firstNameCtrl,
            hintText: 'Stephen',
            errorBool: !_isFormValid && !_isFirstNameValid,
            onChanged: (value) => _validateForm(),
          ),
          SizedBox(
            height: 16.h,
          ),
          InputTitle(
            text: "Last Name",
          ),
          TextInputField(
            controller: _lastNameCtrl,
            hintText: "Reign",
            errorBool: !_isFormValid && !_isLastNameValid,
            onChanged: (value) => _validateForm(),
          ),
          SizedBox(
            height: 16.h,
          ),
          InputTitle(
            text: "Email Address",
          ),
          TextInputField(
            controller: _emailCtrl,
            hintText: "stephenreign@gmail.com",
            errorBool: !_isFormValid && !_isEmailValid,
            textInputType: TextInputType.emailAddress,
            onChanged: (value) => _validateForm(),
          ),
          SizedBox(
            height: 16.h,
          ),
          InputTitle(
            text: "Phone Number",
          ),
          TextInputField(
            controller: _phoneCtrl,
            hintText: "00000000000",
            errorBool: !_isFormValid && !_isPhoneValid,
            textInputType: TextInputType.phone,
            onChanged: (value) => _validateForm(),
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "+${widget.params.country.phoneCode}",
                    style: TextStyles.normalRegular14(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameForm() {
    return Form(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: [
          InputTitle(
            text: "Your Preferred Username",
          ),
          TextInputField(
            controller: _userCtrl,
            hintText: "@username",
            errorBool: !_isFormValid && !_isUserValid,
            onChanged: (value) => _validateForm(),
          ),
          SizedBox(
            height: 16.h,
          ),
          InputTitle(
            text: "Referral Code",
          ),
          TextInputField(
            controller: _refCodeCtrl,
            hintText: "Optional",
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Form(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: [
          InputTitle(
            text: "Create Password",
          ),
          TextInputField(
            controller: _passwordCtrl,
            hintText: "Enter your password",
            isPassword: true,
            errorBool: !_isFormValid && !_isPasswordValid,
            onChanged: (value) => _validateForm(),
          ),
          SizedBox(
            height: 5.h,
          ),
          RichText(
            text: TextSpan(
              text: "Must be at least 8 characters.",
              style: TextStyles.cardRegular10(context).copyWith(
                color: AppColors.black40,
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          InputTitle(
            text: "Confirm Password",
          ),
          TextInputField(
            controller: _confirmCtrl,
            hintText: "Confirm your password",
            isPassword: true,
            errorBool: !_isFormValid && !_isConfirmPasswordValid,
            onChanged: (value) => _validateForm(),
          ),
        ],
      ),
    );
  }
}

class CreateAccountPageParam {
  final Country country;

  CreateAccountPageParam({required this.country});
}
