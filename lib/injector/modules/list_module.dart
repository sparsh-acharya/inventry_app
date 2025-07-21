import 'package:get_it/get_it.dart';
import 'package:inventry_app/features/list/data/datasource/firebase_list_datasource_impl.dart';
import 'package:inventry_app/features/list/data/datasource/list_datasource.dart';
import 'package:inventry_app/features/list/data/repo/list_repo_impl.dart';
import 'package:inventry_app/features/list/domain/repo/list_repo.dart';
import 'package:inventry_app/features/list/domain/usecases/add_item_usecase.dart';
import 'package:inventry_app/features/list/domain/usecases/delete_item_usecase.dart';
import 'package:inventry_app/features/list/domain/usecases/edit_item_usecase.dart';
import 'package:inventry_app/features/list/domain/usecases/fetch_items_usecase.dart';
import 'package:inventry_app/features/list/presentation/bloc/list_bloc.dart';

final sl = GetIt.I;

Future<void> initListModule() async {
  sl.registerLazySingleton<ListDatasource>(() => FirebaseListDatasourceImpl());
  sl.registerLazySingleton<ListRepo>(() => ListRepoImpl(datasource: sl()));
  sl.registerLazySingleton(() => AddItemUsecase(repo: sl()));
  sl.registerLazySingleton(() => FetchItemsUsecase(repo: sl()));
  sl.registerLazySingleton(() => DeleteItemUsecase(repo: sl()));
  sl.registerLazySingleton(() => EditItemUsecase(repo: sl()));
  sl.registerFactory(
    () => ListBloc(
      addItem: sl(),
      fetchItems: sl(),
      deleteItem: sl(),
      editItem: sl(),
    ),
  );
}
