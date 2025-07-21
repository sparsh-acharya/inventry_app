import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class IsNewUserUsecase extends UseCase<bool,String>{
  final UserRepository repo;

  IsNewUserUsecase({required this.repo});
  @override
  FutureEither<bool> call(String uid) {
    return repo.isNewUser(uid);

  }
}
