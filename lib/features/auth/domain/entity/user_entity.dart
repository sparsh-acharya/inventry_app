class UserEntity {
  final String uid;
  final String? displayName;
  final String phoneNumber;
  final String? userHandle;
  final String? avatarUrl;

  const UserEntity({
    required this.uid,
    this.displayName,
    required this.phoneNumber,
    this.userHandle,
    this.avatarUrl,
  });

  UserEntity copyWith({
    String? uid,
    String? displayName,
    String? phoneNumber,
    String? userHandle,
    String? avatarUrl,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userHandle: userHandle ?? this.userHandle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
