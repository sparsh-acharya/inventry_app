import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/group/domain/repo/group_repo.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';

class GetGroupMembersUsecase extends UseCase<List<UserEntity>, String> {
  final GroupRepo groupRepo;

  GetGroupMembersUsecase({required this.groupRepo});

  @override
  FutureEither<List<UserEntity>> call(String groupId) async {
    return await groupRepo.getGroupMembers(groupId);
  }
}
