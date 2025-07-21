import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/group/domain/repo/group_repo.dart';



class AddUserToGroupUsecase extends UseCase<void, AddUserToGroupParams> {
  final GroupRepo repo;

  AddUserToGroupUsecase({required this.repo});

  @override
  FutureVoid call(AddUserToGroupParams params) async {
    return await repo.addUserToGroup(
      groupId: params.groupId,
      userId: params.userId,
    );
  }
}
