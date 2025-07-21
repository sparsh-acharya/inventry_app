import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/list/domain/repo/list_repo.dart';

class DeleteItemUsecase extends UseCase<void, DeleteItemParams> {
  final ListRepo repo;

  DeleteItemUsecase({required this.repo});

  @override
  FutureVoid call(DeleteItemParams params) async {
    return await repo.deleteItem(
      groupId: params.groupId,
      itemId: params.itemId,
    );
  }
}
