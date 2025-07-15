import 'package:get_it/get_it.dart';
import 'package:inventry_app/features/auth/data/datasource/datasource.dart';

import 'package:inventry_app/features/auth/data/datasource/firebase_datasource_impl.dart';
import 'package:inventry_app/features/auth/data/repo/auth_repo_impl.dart';
import 'package:inventry_app/features/auth/domain/usecase/get_currentuser_usecase.dart';
import 'package:inventry_app/features/auth/domain/usecase/send_otp_usecase.dart';
import 'package:inventry_app/features/auth/domain/usecase/signout_usecase.dart';
import 'package:inventry_app/features/auth/domain/usecase/verify_opt_usecase.dart';
import 'package:inventry_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:inventry_app/features/auth/domain/repo/auth_repo.dart';

final sl = GetIt.I;

Future<void> initAuthModule() async {
  sl.registerLazySingleton<AuthDatasource>(() => FirebaseAuthDatasource());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SendOtpUsecase(repo: sl()));
  sl.registerLazySingleton(() => VerifyOptUsecase(repo: sl()));
  sl.registerLazySingleton(() => GetCurrentuserUsecase(repo: sl()));
  sl.registerLazySingleton(() => SignoutUsecase(repo: sl()));
  sl.registerFactory(
    () => AuthBloc(
      sendOtp: sl(),
      verifyOtp: sl(),
      getCurrentUser: sl(),
      signOut: sl(),
    ),
  );
}
