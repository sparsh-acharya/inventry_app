class UserEntity {
  final String uid;
  final String? displayName;
  final String phoneNumber;
  final String? userHandle;

  const UserEntity({
    required this.uid,
    this.displayName,
    required this.phoneNumber,
    this.userHandle,
  });

  UserEntity copyWith({
    String? uid,
    String? displayName,
    String? phoneNumber,
    String? userHandle,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userHandle: userHandle ?? this.userHandle,
    );
  }
}
