import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/list/domain/entities/list_entity.dart';
import 'package:inventry_app/features/list/domain/repo/list_repo.dart';

class FetchItemsUsecase extends UseCase<Stream<List<ListEntity>>,String>{
  final ListRepo repo;

  FetchItemsUsecase({required this.repo});
  @override
  FutureEither<Stream<List<ListEntity>>> call(String groupId) async {
    return await repo.getItems(groupId);
  }
}
