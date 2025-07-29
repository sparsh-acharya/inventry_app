class ListEntity {
  final String uid;
  final String name;
  final int itemCount;
  final String unit;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool automationEnabled;
  final int? consumptionRate;
  final int? notificationThreshold;

  final DateTime? automationStartDate;

  ListEntity({
    required this.uid,
    required this.name,
    required this.itemCount,
    required this.unit,
    required this.createdAt,
    required this.updatedAt,
    this.automationEnabled = false,
    this.consumptionRate,
    this.notificationThreshold,
    this.automationStartDate,
  });

  ListEntity copyWith({
    String? uid,
    String? name,
    int? itemCount,
    String? unit,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? automationEnabled,
    int? consumptionRate,
    int? notificationThreshold,
    DateTime? automationStartDate,
  }) {
    return ListEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      itemCount: itemCount ?? this.itemCount,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      automationEnabled: automationEnabled ?? this.automationEnabled,
      consumptionRate: consumptionRate ?? this.consumptionRate,
      notificationThreshold: notificationThreshold ?? this.notificationThreshold,
      automationStartDate: automationStartDate ?? this.automationStartDate,
    );
  }
}
