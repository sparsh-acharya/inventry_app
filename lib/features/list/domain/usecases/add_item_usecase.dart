import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/list/domain/repo/list_repo.dart';

class AddItemUsecase extends UseCase<void,AddItemParams>{
  final ListRepo repo;

  AddItemUsecase({required this.repo});
  @override
  FutureEither<void> call(AddItemParams params) async {
    return await repo.addItem(params.itemName, params.count, params.unit, params.groupId);
  }
}
