import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/group/data/models/group_model.dart';

abstract class GroupDatasource {
  FutureEither<List<GroupModel>?> getGroups(String userId);
  FutureVoid createGroup(String groupName,String adminId);
  FutureVoid deleteGroup(String groupId,String adminId);
  FutureVoid addUserToGroup({required String groupId, required String userId});
}
