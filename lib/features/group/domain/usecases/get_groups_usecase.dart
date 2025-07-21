import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/group/data/models/group_model.dart';
import 'package:inventry_app/features/group/domain/entities/group_entity.dart';
import 'package:inventry_app/features/group/domain/repo/group_repo.dart';

class GetGroupsUsecase extends UseCase<List<GroupEntity>?, String> {
  final GroupRepo repo;

  GetGroupsUsecase({required this.repo});
  @override
  FutureEither<List<GroupEntity>?> call(String uid) async {
    return await repo.getGroups(uid);
  }
}
