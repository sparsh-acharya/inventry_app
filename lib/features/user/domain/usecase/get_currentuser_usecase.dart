import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class GetCurrentuserUsecase extends UseCase<UserEntity?,NoParams>{
  final UserRepository repo;

  GetCurrentuserUsecase({required this.repo});

  @override
  FutureEither<UserEntity?> call(NoParams params) {
    return repo.getCurrentUser();
  }



}
