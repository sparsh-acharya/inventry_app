// ignore_for_file: public_member_api_docs, sort_constructors_first



class AvatarEntity {
  final String uid;
  final String url;

  AvatarEntity({required this.uid, required this.url});

  AvatarEntity copyWith({String? uid, String? url}) {
    return AvatarEntity(uid: uid ?? this.uid, url: url ?? this.url);
  }


}
