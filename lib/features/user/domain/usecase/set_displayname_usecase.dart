import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/usecase/usecase.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class SetDisplaynameUsecase extends UseCase<void,String>{
  final UserRepository repo;

  SetDisplaynameUsecase({required this.repo});
  @override
  Future<Either<Failure, void>> call(String name) {
    return repo.setDisplayName(name);

  }
}
