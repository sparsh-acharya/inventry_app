import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/usecase/usecase.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class IsNewUserUsecase extends UseCase<bool,String>{
  final UserRepository repo;

  IsNewUserUsecase({required this.repo});
  @override
  Future<Either<Failure, bool>> call(String uid) {
    return repo.isNewUser(uid);

  }
}
