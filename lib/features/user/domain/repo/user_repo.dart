import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/user/domain/entity/avatar_entity.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';

abstract class UserRepository {
  FutureEither<UserEntity?> getCurrentUser();
  FutureEither<List<AvatarEntity>> getAvatars();
  FutureVoid setDisplayName(String name);
  FutureEither<bool> isNewUser(String uid);
  FutureVoid createUserInFirestore({required String uid,required String phone, required String displayName});
  FutureVoid claimUserHandle({required String uid, required String handle, required String phone,required String displayName});
  FutureEither<UserEntity?> findUserByHandle(String handle);
}
