import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/user/data/models/avatar_model.dart';
import 'package:inventry_app/features/user/data/models/user_model.dart';

abstract class UserDatasource {
  FutureEither<UserModel?> getCurrentUser();
  FutureEither<List<AvatarModel>> getAvatars();
  FutureVoid setDisplayName(String name);
  FutureEither<bool> isNewUser(String uid);
  FutureVoid createUserInFirestore({required String uid, required String phone, required String displayName, String? avatarUrl});
  FutureVoid claimUserHandle({required String uid, required String handle,required String phone, required String displayName, String? avatarUrl});
  FutureEither<UserModel?> findUserByHandle(String handle);
  FutureEither<String?> requestFCMToken();
  FutureVoid saveFCMToken(String token);
}
