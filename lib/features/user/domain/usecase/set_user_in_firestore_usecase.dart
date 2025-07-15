import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/usecase/usecase.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class SetUserInFirestoreParams {
  final String uid;
  final String displayName;
  final String phone;
  SetUserInFirestoreParams({required this.uid, required this.displayName,required this.phone});
}

class SetUserInFirestoreUsecase extends UseCase<void, SetUserInFirestoreParams> {
  final UserRepository repo;
  SetUserInFirestoreUsecase({required this.repo});

  @override
  Future<Either<Failure, void>> call(SetUserInFirestoreParams params) {
    return repo.createUserInFirestore(uid: params.uid, displayName: params.displayName, phone: params.phone);
  }
}
