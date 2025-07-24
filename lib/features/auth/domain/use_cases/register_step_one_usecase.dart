

import '../../../../core/model/api_model.dart';
import '../../data/models/step_one_request_model.dart';
import '../repositories/auth_repository.dart';

class RegisterStepOneUseCase {
  final AuthRepository authRepository;

  RegisterStepOneUseCase({required this.authRepository});

  Future<ApiResponse<String>> call({
    required StepOneRequestModel request,
  }) async {
    return await authRepository.registerStepOne(
      request: request,
    );
  }
}
