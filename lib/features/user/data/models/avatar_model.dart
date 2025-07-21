import 'dart:convert';

import 'package:inventry_app/features/user/domain/entity/avatar_entity.dart';

class AvatarModel extends AvatarEntity {
  AvatarModel({required super.uid, required super.url});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'uid': uid, 'url': url};
  }

  factory AvatarModel.fromMap(Map<String, dynamic> map) {
    return AvatarModel(uid: map['uid'] as String, url: map['url'] as String);
  }

  String toJson() => json.encode(toMap());

  factory AvatarModel.fromJson(String source) =>
      AvatarModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
