import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    super.displayName,
    required super.phoneNumber,
    super.userHandle,
    super.avatarUrl,
    super.fcmToken,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber!,
      // userHandle and avatarUrl will be fetched from Firestore, not Firebase Auth
    );
  }

  // You'll need a way to create a UserModel from a Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      displayName: data['displayName'],
      phoneNumber: data['phone'],
      userHandle: data['userHandle'],
      avatarUrl: data['avatarUrl'],
    );
  }
}
