
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventry_app/features/list/domain/entities/list_entity.dart';

class ListModel extends ListEntity {
  ListModel({
    required super.uid,
    required super.name,
    required super.itemCount,
    required super.unit,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'itemCount': itemCount,
      'unit': unit,
      'createdAt': Timestamp.fromDate(createdAt)
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      itemCount: map['itemCount'] as int,
      unit: map['unit'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate()
    );
  }

  String toJson() => json.encode(toMap());

  factory ListModel.fromJson(String source) =>
      ListModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
