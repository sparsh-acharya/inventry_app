import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/list/domain/repo/list_repo.dart';

class EditItemUsecase extends UseCase<void, EditItemParams> {
  final ListRepo repo;

  EditItemUsecase({required this.repo});

  @override
  FutureVoid call(EditItemParams params) async {
    return await repo.editItem(
      groupId: params.groupId,
      itemId: params.itemId,
      itemName: params.itemName,
      itemCount: params.count,
      unit: params.unit,
    );
  }
}
