import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/group/domain/repo/group_repo.dart';

class RemoveUserFromGroupUsecase
    extends UseCase<void, RemoveUserFromGroupParams> {
  final GroupRepo groupRepo;

  RemoveUserFromGroupUsecase({required this.groupRepo});

  @override
  FutureVoid call(RemoveUserFromGroupParams params) async {
    return await groupRepo.removeUserFromGroup(
      groupId: params.groupId,
      userId: params.userId,
    );
  }
}
