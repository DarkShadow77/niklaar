import 'package:get_it/get_it.dart';

import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impli.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_cases/register_step_one_usecase.dart';
import '../../features/auth/domain/use_cases/register_step_two_usecase.dart';
import '../../features/auth/presentation/manager/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // Remote data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl<AuthRemoteDataSource>(),
    ),
  );

  // Use Cases
  //🐛 Auth Use Cases
  sl.registerLazySingleton<RegisterStepOneUseCase>(
    () => RegisterStepOneUseCase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterStepTwoUseCase>(
    () => RegisterStepTwoUseCase(authRepository: sl<AuthRepository>()),
  );

  // Blocs (Factories - because Blocs are short-lived)
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      registerStepOneUseCase: sl<RegisterStepOneUseCase>(),
      registerStepTwoUseCase: sl<RegisterStepTwoUseCase>(),
    ),
  );
}
