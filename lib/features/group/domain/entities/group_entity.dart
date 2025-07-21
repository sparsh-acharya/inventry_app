
class GroupEntity {
  final String groupName;
  final String uid;
  final String admin;
  final List<String> members;
  final DateTime createdAt;

  GroupEntity({
    required this.groupName,
    required this.uid,
    required this.admin,
    required this.members,
    required this.createdAt,
  });

  GroupEntity copyWith({
    String? groupName,
    String? uid,
    String? admin,
    List<String>? members,
    DateTime? createdAt,
  }) {
    return GroupEntity(
      groupName: groupName ?? this.groupName,
      uid: uid ?? this.uid,
      admin: admin ?? this.admin,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
