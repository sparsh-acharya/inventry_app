import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/group/domain/entities/group_entity.dart';

abstract class GroupRepo {
  FutureEither<List<GroupEntity>?> getGroups(String userId);
  FutureVoid createGroup(String groupName,String adminId );
  FutureVoid deleteGroup(String groupId, String adminId);
  FutureVoid addUserToGroup({required String groupId, required String userId});
}
