class ListEntity {
  final String uid;
  final String name;
  final int itemCount;
  final String unit;
  final DateTime createdAt;

  ListEntity({
    required this.uid,
    required this.name,
    required this.itemCount,
    required this.unit,
    required this.createdAt,
  });

  ListEntity copyWith({
    String? uid,
    String? name,
    int? count,
    String? unit,
    DateTime? createdAt,
  }) {
    return ListEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      itemCount: count ?? this.itemCount,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
