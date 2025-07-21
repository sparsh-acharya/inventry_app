import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/list/data/models/list_model.dart';

abstract class ListDatasource {
  FutureVoid addItem(String itemName,int itemCount,String unit,String groupId);
  Stream<List<ListModel>> getItems(String groupId);
  FutureVoid deleteItem({required String groupId, required String itemId});
  FutureVoid editItem({
    required String groupId,
    required String itemId,
    required String itemName,
    required int itemCount,
    required String unit,
  });
}
