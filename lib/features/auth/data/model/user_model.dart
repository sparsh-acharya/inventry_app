import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventry_app/features/auth/domain/entity/user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.uid,
    super.displayName,
    required super.phoneNumber,
    super.userHandle,
    super.avatarUrl,
  });

  factory AuthUserModel.fromFirebaseUser(User user) {
    return AuthUserModel(
      uid: user.uid,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber!,
      // userHandle and avatarUrl will be fetched from Firestore, not Firebase Auth
    );
  }

  // You'll need a way to create a UserModel from a Firestore document
  factory AuthUserModel.fromFirestore(Map<String, dynamic> data) {
    return AuthUserModel(
      uid: data['uid'],
      displayName: data['displayName'],
      phoneNumber: data['phone'],
      userHandle: data['userHandle'],
      avatarUrl: data['avatarUrl'],
    );
  }
}
