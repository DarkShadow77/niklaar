import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../../../core/utils/local_storage.dart';
import '../../data/models/step_one_request_model.dart';
import '../../data/models/step_two_request_model.dart';
import '../../domain/use_cases/register_step_one_usecase.dart';
import '../../domain/use_cases/register_step_two_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterStepOneUseCase registerStepOneUseCase;
  final RegisterStepTwoUseCase registerStepTwoUseCase;
  AuthBloc({
    required this.registerStepOneUseCase,
    required this.registerStepTwoUseCase,
  }) : super(AuthInitialState()) {
    on<RegisterStepOneEvent>(_onRegisterStepOne);
    on<RegisterStepTwoEvent>(_onRegisterStepTwo);
  }

  Future<void> _onRegisterStepOne(
      RegisterStepOneEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final response = await registerStepOneUseCase.call(
      request: event.request,
    );

    if (response.responseSuccessful!) {
      Logger().t(
          "Step On Registered Successfully ${response.responseMessage!},${response.responseBody!}");

      emit(
        AuthSuccessState(
          authType: AuthType.registerStepOne,
          message: "Step On Registered Successfully",
        ),
      );

      LocalStorageHelper().setUserToken(response.responseBody!);
    } else {
      Logger().e("Failed to Register Step One ${response.responseMessage!}");

      emit(
        AuthFailureState(
          authType: AuthType.registerStepOne,
          message: "Failed To Register",
        ),
      );
    }
  }

  Future<void> _onRegisterStepTwo(
      RegisterStepTwoEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final response = await registerStepTwoUseCase.call(
      request: event.request,
    );

    if (response.responseSuccessful!) {
      Logger()
          .t("Step Two Registered Successfully ${response.responseMessage!}");

      emit(
        AuthSuccessState(
          authType: AuthType.registerStepTwo,
          message: "User Registered Successfully",
        ),
      );
    } else {
      Logger().e("Failed to Register Step Two ${response.responseMessage!}");

      emit(
        AuthFailureState(
          authType: AuthType.registerStepTwo,
          message: "Failed To Register",
        ),
      );
    }
  }
}
