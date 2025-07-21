import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventry_app/features/group/domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.groupName,
    required super.uid,
    required super.admin,
    required super.members,
    required super.createdAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      uid: json['uid'] ?? '',
      groupName: json['groupName'] ?? '',
      admin: json['admin'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'groupName': groupName,
      'admin': admin,
      'members': members,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  GroupModel copyWith({
    String? uid,
    String? groupName,
    String? admin,
    List<String>? members,
    DateTime? createdAt,
  }) {
    return GroupModel(
      uid: uid ?? this.uid,
      groupName: groupName ?? this.groupName,
      admin: admin ?? this.admin,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
