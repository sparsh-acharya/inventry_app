import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';
import 'package:inventry_app/core/utils/typedef.dart';
import 'package:inventry_app/features/list/data/datasource/list_datasource.dart';
import 'package:inventry_app/features/list/domain/entities/list_entity.dart';
import 'package:inventry_app/features/list/domain/repo/list_repo.dart';

class ListRepoImpl extends ListRepo {
  final ListDatasource datasource;

  ListRepoImpl({required this.datasource});

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
    return await datasource.addItem(
      itemName,
      itemCount,
      unit,
      groupId,
      automationEnabled: automationEnabled,
      consumptionRate: consumptionRate,
      automationStartDate: automationStartDate,
    );
  }

  @override
  FutureEither<Stream<List<ListEntity>>> getItems(String groupId) async {
    try {
      final stream = datasource.getItems(groupId);
      return Right(stream);
    } catch (e) {
      return Left(FirebaseError(message: e.toString()));
    }
  }

  @override
  FutureVoid deleteItem({
    required String groupId,
    required String itemId,
  }) async {
    return await datasource.deleteItem(groupId: groupId, itemId: itemId);
  }

  @override
  FutureVoid editItem({
    required String groupId,
    required String itemId,
    required String itemName,
    required int itemCount,
    required String unit,
  }) async {
    return await datasource.editItem(
      groupId: groupId,
      itemId: itemId,
      itemName: itemName,
      itemCount: itemCount,
      unit: unit,
    );
  }
}
