import '../../../../core/constants/url_path.dart';
import '../../../../core/model/api_model.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/utils/local_storage.dart';
import '../models/step_one_request_model.dart';
import '../models/step_two_request_model.dart';

class AuthRemoteDataSource {
  Future<ApiResponse<String>> registerStepOne(
      {required StepOneRequestModel body}) {
    final response = ApiService.instance!.postRequestHandler(
      AuthUrl.register,
      body.toJson(),
      transform: (dynamic dataSection) {
        return dataSection['access_token'] as String;
      },
    );

    return response;
  }

  Future<ApiResponse> registerStepTwo({required StepTwoRequestModel body}) {
    final response = ApiService.instance!.postRequest(
      AuthUrl.register2,
      body.toJson(),
      accessToken: LocalStorageHelper().getUserToken(),
    );

    return response;
  }
}
