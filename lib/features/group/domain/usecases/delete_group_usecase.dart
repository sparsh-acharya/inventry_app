import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/group/domain/repo/group_repo.dart';

class DeleteGroupUsecase extends UseCase<void, DeleteGroupParams> {
  final GroupRepo repo;

  DeleteGroupUsecase({required this.repo});
  @override
  FutureVoid call(DeleteGroupParams params) async {
    return await repo.deleteGroup(params.groupId, params.adminId);
  }
}
