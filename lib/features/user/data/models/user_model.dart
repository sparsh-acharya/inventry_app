import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    super.displayName,
    required super.phoneNumber,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
    );
  }

  @override
  UserModel copyWith({
    String? uid,
    String? displayName,
    String? phoneNumber,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
