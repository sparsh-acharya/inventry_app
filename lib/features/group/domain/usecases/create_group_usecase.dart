import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/group/domain/repo/group_repo.dart';

class CreateGroupUsecase extends UseCase<void,CreateGroupParams>{
  final GroupRepo repo;

  CreateGroupUsecase({required this.repo});

  @override
  FutureVoid call(CreateGroupParams params) async {
    return await repo.createGroup(params.groupName, params.adminId);
  }
}
