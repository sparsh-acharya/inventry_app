import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/user/data/datasource/user_datasource.dart';
import 'package:inventry_app/features/user/data/models/user_model.dart';
import 'package:inventry_app/features/user/domain/entity/avatar_entity.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';
import 'package:inventry_app/features/user/domain/repo/user_repo.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  FutureEither<UserModel?> getCurrentUser() => datasource.getCurrentUser();

  @override
  FutureVoid setDisplayName(String name) async {
    try {
      await datasource.setDisplayName(name);
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureEither<bool> isNewUser(String uid) async {
    try {
      return await datasource.isNewUser(uid);
    } catch (e) {
      return left(
        FirebaseError(
          message: 'something went wrong in isnewuser userrepo impl',
        ),
      );
    }
  }

  @override
  FutureVoid createUserInFirestore({
    required String uid,
    required String phone,
    required String displayName,
  }) async {
    try {
      return await datasource.createUserInFirestore(
        uid: uid,
        displayName: displayName,
        phone: phone,
      );
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid claimUserHandle({
    required String uid,
    required String handle,
    required String phone,
    required String displayName,
  }) async {
    return await datasource.claimUserHandle(
      uid: uid,
      handle: handle,
      displayName: displayName,
      phone: phone,
    );
  }

  @override
  FutureEither<UserEntity?> findUserByHandle(String handle) async {
    return await datasource.findUserByHandle(handle);
  }

  @override
  FutureEither<List<AvatarEntity>> getAvatars() async {
    return await datasource.getAvatars();
  }
}
