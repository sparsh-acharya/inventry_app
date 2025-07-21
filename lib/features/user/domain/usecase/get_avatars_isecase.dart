import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/user/domain/entity/avatar_entity.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class GetAvatarsUsecase extends UseCase<List<AvatarEntity>, NoParams> {
  final UserRepository repo;

  GetAvatarsUsecase({required this.repo});

  @override
  FutureEither<List<AvatarEntity>> call(NoParams params) async {
    return await repo.getAvatars();
  }
}
