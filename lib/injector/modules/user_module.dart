import 'package:get_it/get_it.dart';
import 'package:inventry_app/features/user/domain/usecase/clain_handle_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/find_user_by_handle_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/get_avatars_isecase.dart';
import 'package:inventry_app/features/user/domain/usecase/get_currentuser_usecase.dart';
import 'package:inventry_app/features/user/data/datasource/firebase_datasource_impl.dart';
import 'package:inventry_app/features/user/data/datasource/user_datasource.dart';
import 'package:inventry_app/features/user/data/repo/user_repo_impl.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';
import 'package:inventry_app/features/user/domain/usecase/is_new_user_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/set_displayname_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/set_user_in_firestore_usecase.dart';
import 'package:inventry_app/features/user/presentation/bloc/user_bloc.dart';

final sl = GetIt.I;

Future<void> initUserModule() async {
  sl.registerLazySingleton<UserDatasource>(() => FirebaseUserDatasourceImpl());
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(datasource: sl()),
  );
  sl.registerLazySingleton(() => GetCurrentuserUsecase(repo: sl()));
  sl.registerLazySingleton(() => SetDisplaynameUsecase(repo: sl()));
  sl.registerLazySingleton(() => IsNewUserUsecase(repo: sl()));
  sl.registerLazySingleton(() => ClaimHandleUsecase(repo: sl()));
  sl.registerLazySingleton(() => FindUserByHandleUsecase(repo: sl()));
  sl.registerLazySingleton(() => GetAvatarsUsecase(repo: sl()));

  sl.registerFactory(
    () => UserBloc(
      getCurrentUser: sl(),
      setDisplayName: sl(),
      isNewUser: sl(),
      claimUserHandle: sl(),
      getAvatars: sl(),
    ),
  );
}
