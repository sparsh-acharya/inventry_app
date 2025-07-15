class UserEntity {
  final String uid;
  final String? displayName;
  final String phoneNumber;

  const UserEntity({required this.uid, this.displayName, required this.phoneNumber});

  UserEntity copyWith({
    String? uid,
    String? displayName,
    String? phoneNumber,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
