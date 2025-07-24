import '../../../../core/constants/url_path.dart';
import '../../../../core/model/api_model.dart';
import '../../../../core/services/api_service.dart';
import '../models/step_one_request_model.dart';
import '../models/step_two_request_model.dart';

class AuthRemoteDataSource {
  Future<ApiResponse> registerStepOne({required StepOneRequestModel body}) {
    final response = ApiService.instance!.deleteRequest(
      AuthUrl.register,
      body.toJson(),
    );

    return response;
  }

  Future<ApiResponse> registerStepTwo({required StepTwoRequestModel body}) {
    final response = ApiService.instance!.deleteRequest(
      AuthUrl.register2,
      body.toJson(),
    );

    return response;
  }
}
