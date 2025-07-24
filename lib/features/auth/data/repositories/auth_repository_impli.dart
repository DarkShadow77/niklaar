import '../../../../core/model/api_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/step_one_request_model.dart';
import '../models/step_two_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
  });

  @override
  Future<ApiResponse> registerStepOne({
    required StepOneRequestModel request,
  }) async {
    return await authRemoteDataSource.registerStepOne(
      body: request,
    );
  }

  @override
  Future<ApiResponse> registerStepTwo({
    required StepTwoRequestModel request,
  }) async {
    return await authRemoteDataSource.registerStepTwo(
      body: request,
    );
  }
}
