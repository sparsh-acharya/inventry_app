part of 'list_bloc.dart';

sealed class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object> get props => [];
}

class AddItemEvent extends ListEvent {
  final String groupId;
  final String itemName;
  final int count;
  final String unit;
  final bool automationEnabled;
  final int? consumptionRate;
  final DateTime? automationStartDate;

  const AddItemEvent({
    required this.groupId,
    required this.itemName,
    required this.count,
    required this.unit,
    this.automationEnabled = false,
    this.consumptionRate,
    this.automationStartDate,
  });

  @override
  List<Object> get props => [groupId, itemName, count, unit];
}

class FetchItemsEvent extends ListEvent {
  final String groupId;

  const FetchItemsEvent({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class _ItemsUpdated extends ListEvent {
  final List<ListEntity> items;

  const _ItemsUpdated(this.items);

  @override
  List<Object> get props => [items];
}

class DeleteItemEvent extends ListEvent {
  final String groupId;
  final String itemId;

  const DeleteItemEvent({required this.groupId, required this.itemId});

  @override
  List<Object> get props => [groupId, itemId];
}

class EditItemEvent extends ListEvent {
  final String groupId;
  final String itemId;
  final String itemName;
  final int count;
  final String unit;

  const EditItemEvent({
    required this.groupId,
    required this.itemId,
    required this.itemName,
    required this.count,
    required this.unit,
  });

  @override
  List<Object> get props => [groupId, itemId, itemName, count, unit];
}
