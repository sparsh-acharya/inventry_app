import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/auth/domain/entity/user_entity.dart';
import 'package:inventry_app/features/auth/domain/repo/auth_repo.dart';

class GetCurrentuserUsecase extends UseCase<UserEntity?,NoParams> {
  final AuthRepository repo;

  GetCurrentuserUsecase({required this.repo});

  @override
  FutureEither<UserEntity?> call(NoParams param) {
    return repo.getCurrentUser();
  }
}
