import '../../../../core/model/api_model.dart';
import '../../data/models/step_two_request_model.dart';
import '../repositories/auth_repository.dart';

class RegisterStepTwoUseCase {
  final AuthRepository authRepository;

  RegisterStepTwoUseCase({required this.authRepository});

  Future<ApiResponse> call({
    required StepTwoRequestModel request,
  }) async {
    return await authRepository.registerStepTwo(
      request: request,
    );
  }
}
