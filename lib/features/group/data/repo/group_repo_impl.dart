import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/group/data/datasource/group_datasource.dart';
import 'package:inventry_app/features/group/domain/entities/group_entity.dart';
import 'package:inventry_app/features/group/domain/repo/group_repo.dart';

class GroupRepoImpl extends GroupRepo {
  final GroupDatasource datasource;

  GroupRepoImpl({required this.datasource});

  @override
  FutureVoid createGroup(String groupName, String adminId) async {
    return await datasource.createGroup(groupName, adminId);
  }

  @override
  FutureEither<List<GroupEntity>?> getGroups(String userId) async {
    return await datasource.getGroups(userId);
  }

  @override
  FutureVoid deleteGroup(String groupId,String adminId) async {
    return await datasource.deleteGroup(groupId,adminId);

  }
  @override
  FutureVoid addUserToGroup({required String groupId, required String userId}) async {
    return await datasource.addUserToGroup(groupId: groupId, userId: userId);
  }
}
