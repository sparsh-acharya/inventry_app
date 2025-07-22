import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/list/domain/entities/list_entity.dart';

abstract class ListRepo {
  FutureVoid addItem(
    String itemName,
    int itemCount,
    String unit,
    String groupId, {
    bool automationEnabled = false,
    int? consumptionRate,
    DateTime? automationStartDate,
  });
  FutureEither<Stream<List<ListEntity>>> getItems(String groupId);
  FutureVoid deleteItem({required String groupId, required String itemId});
  FutureVoid editItem({
    required String groupId,
    required String itemId,
    required String itemName,
    required int itemCount,
    required String unit,
  });
}
