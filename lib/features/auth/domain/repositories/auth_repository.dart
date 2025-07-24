import 'package:niklaar/features/auth/data/models/step_one_request_model.dart';

import '../../../../core/model/api_model.dart';
import '../../data/models/step_two_request_model.dart';

abstract class AuthRepository {
  Future<ApiResponse<String>> registerStepOne({
    required StepOneRequestModel request,
  });
  Future<ApiResponse> registerStepTwo({
    required StepTwoRequestModel request,
  });
}
