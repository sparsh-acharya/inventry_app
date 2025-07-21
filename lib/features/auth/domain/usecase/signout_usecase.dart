import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/auth/domain/repo/auth_repo.dart';

class SignoutUsecase extends UseCase<void,NoParams> {
  final AuthRepository repo;

  SignoutUsecase({required this.repo});

  @override
  FutureVoid call(NoParams param) {
    return repo.signOut();
  }
}
