import 'package:get_it/get_it.dart';
import 'package:inventry_app/features/group/data/datasource/firebase_group_datasource_impl.dart';
import 'package:inventry_app/features/group/data/datasource/group_datasource.dart';
import 'package:inventry_app/features/group/data/repo/group_repo_impl.dart';
import 'package:inventry_app/features/group/domain/repo/group_repo.dart';
import 'package:inventry_app/features/group/domain/usecases/add_user_to_group_usecase.dart';
import 'package:inventry_app/features/group/domain/usecases/create_group_usecase.dart';
import 'package:inventry_app/features/group/domain/usecases/delete_group_usecase.dart';
import 'package:inventry_app/features/group/domain/usecases/get_groups_usecase.dart';
import 'package:inventry_app/features/group/presentation/bloc/group_bloc.dart';

final sl = GetIt.I;

Future<void> initGroupModule() async {
  sl.registerLazySingleton<GroupDatasource>(
    () => FirebaseGroupDatasourceImpl(),
  );
  sl.registerLazySingleton<GroupRepo>(() => GroupRepoImpl(datasource: sl()));
  sl.registerLazySingleton(() => GetGroupsUsecase(repo: sl()));
  sl.registerLazySingleton(() => CreateGroupUsecase(repo: sl()));
  sl.registerLazySingleton(() => DeleteGroupUsecase(repo: sl()));
  sl.registerLazySingleton(() => AddUserToGroupUsecase(repo: sl()));
  sl.registerFactory(
    () => GroupBloc(
      getGroups: sl(),
      createGroup: sl(),
      deleteGroup: sl(),
      findUserByHandle: sl(),
      addUserToGroup: sl(),
    ),
  );
}
