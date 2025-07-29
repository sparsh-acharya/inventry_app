import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/group/domain/repo/group_repo.dart';

class UpdateGroupnameUsecase extends UseCase<void, UpdateGroupnameParams> {
  final GroupRepo groupRepo;

  UpdateGroupnameUsecase({required this.groupRepo});

  @override
  FutureVoid call(UpdateGroupnameParams params) async {
    return await groupRepo.updateGroupName(params.groupId, params.newName);
  }
}


