import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/features/user/data/models/user_model.dart';

abstract class UserDatasource {
  Future<Either<Failure,UserModel?>> getCurrentUser();
  Future<Either<Failure,void>> setDisplayName(String name);
  Future<Either<Failure,bool>> isNewUser(String uid);
  Future<Either<Failure,void>> createUserInFirestore({required String uid, required String phone, required String displayName});

}
