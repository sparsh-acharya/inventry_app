import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/features/user/data/datasource/user_datasource.dart';
import 'package:inventry_app/features/user/data/models/user_model.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class UserRepositoryImpl extends UserRepository{
  final UserDatasource datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure,UserModel?>> getCurrentUser() => datasource.getCurrentUser();

  @override
  Future<Either<Failure, void>> setDisplayName(String name) async {
    try {
      await datasource.setDisplayName(name);
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isNewUser(String uid) async {
    try {
      return await datasource.isNewUser(uid);
    } catch (e) {
      return left(FirebaseError(message: 'something went wrong in isnewuser userrepo impl'));
    }


  }

  @override
  Future<Either<Failure, void>> createUserInFirestore({required String uid,required String phone, required String displayName}) async {
    try {
      return await datasource.createUserInFirestore(uid: uid, displayName: displayName, phone: phone);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }
}
