import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class FindUserByHandleUsecase extends UseCase<UserEntity?, String> {
  final UserRepository repo;

  FindUserByHandleUsecase({required this.repo});

  @override
  FutureEither<UserEntity?> call(String handle) {
    return repo.findUserByHandle(handle);
  }
}
