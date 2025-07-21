class ListEntity {
  final String uid;
  final String name;
  final int itemCount;
  final String unit;
  final DateTime createdAt;
  final bool automationEnabled;
  final int? consumptionRate; // e.g., 3 (items per day)
  final DateTime? automationStartDate;

  ListEntity({
    required this.uid,
    required this.name,
    required this.itemCount,
    required this.unit,
    required this.createdAt,
    this.automationEnabled = false,
    this.consumptionRate,
    this.automationStartDate,
  });

  ListEntity copyWith({
    String? uid,
    String? name,
    int? count,
    String? unit,
    DateTime? createdAt,
    bool? automationEnabled,
    int? consumptionRate,
    DateTime? automationStartDate,
  }) {
    return ListEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      itemCount: count ?? this.itemCount,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      automationEnabled: automationEnabled ?? this.automationEnabled,
      consumptionRate: consumptionRate ?? this.consumptionRate,
      automationStartDate: automationStartDate ?? this.automationStartDate,
    );
  }
}
