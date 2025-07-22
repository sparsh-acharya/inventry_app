import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/list/data/datasource/list_datasource.dart';
import 'package:inventry_app/features/list/data/models/list_model.dart';

class FirebaseListDatasourceImpl extends ListDatasource {
  final _store = FirebaseFirestore.instance;

  @override
  FutureVoid addItem(
    String itemName,
    int itemCount,
    String unit,
    String groupId, {
    bool automationEnabled = false,
    int? consumptionRate,
    DateTime? automationStartDate,
  }) async {
    try {
      final itemDoc =
          _store.collection('groups').doc(groupId).collection('items').doc();
      final uid = itemDoc.id;
      final item = ListModel(
        uid: uid,
        name: itemName,
        itemCount: itemCount,
        unit: unit,
        createdAt: DateTime.now(),
        automationEnabled: automationEnabled,
        consumptionRate: consumptionRate,
        automationStartDate: automationStartDate,
      );
      await itemDoc.set(item.toMap());
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  Stream<List<ListModel>> getItems(String groupId) {
    try {
      final itemRef = _store
          .collection('groups')
          .doc(groupId)
          .collection('items');
      return itemRef
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs
                    .map((doc) => ListModel.fromMap(doc.data()))
                    .toList(),
          );
    } catch (e) {
      throw FirebaseException(plugin: 'Firestore', message: e.toString());
    }
  }

  @override
  FutureVoid deleteItem({
    required String groupId,
    required String itemId,
  }) async {
    try {
      await _store
          .collection('groups')
          .doc(groupId)
          .collection('items')
          .doc(itemId)
          .delete();
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid editItem({
    required String groupId,
    required String itemId,
    required String itemName,
    required int itemCount,
    required String unit,
  }) async {
    try {
      await _store
          .collection('groups')
          .doc(groupId)
          .collection('items')
          .doc(itemId)
          .update({'name': itemName, 'itemCount': itemCount, 'unit': unit});
      return right(null);
    } catch (e) {
      return left(FirebaseError(message: e.toString()));
    }
  }
}
