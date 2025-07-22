import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/list/domain/entities/list_entity.dart';
import 'package:inventry_app/features/list/domain/usecases/add_item_usecase.dart';
import 'package:inventry_app/features/list/domain/usecases/delete_item_usecase.dart';
import 'package:inventry_app/features/list/domain/usecases/edit_item_usecase.dart';
import 'package:inventry_app/features/list/domain/usecases/fetch_items_usecase.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final AddItemUsecase addItem;
  final FetchItemsUsecase fetchItems;
  final DeleteItemUsecase deleteItem;
  final EditItemUsecase editItem;
  StreamSubscription<List<ListEntity>>? _itemsSubscription;

  ListBloc({
    required this.addItem,
    required this.fetchItems,
    required this.deleteItem,
    required this.editItem,
  }) : super(ListInitialState()) {
    on<AddItemEvent>(_onAddItem);
    on<FetchItemsEvent>(_onFetchItems);
    on<DeleteItemEvent>(_onDeleteItem);
    on<EditItemEvent>(_onEditItem);
    on<_ItemsUpdated>(
      (event, emit) => emit(ListLoadedState(items: event.items)),
    );
  }

  FutureOr<void> _onAddItem(AddItemEvent event, Emitter<ListState> emit) async {
    final result = await addItem(
      AddItemParams(
        itemName: event.itemName,
        count: event.count,
        unit: event.unit,
        groupId: event.groupId,
        automationEnabled: event.automationEnabled,
        consumptionRate: event.consumptionRate,
        automationStartDate: event.automationStartDate,
      ),
    );
    result.fold(
      (failure) => emit(ListErrorState(message: failure.message)),
      (_) => emit(ListAddedState(name: event.itemName)),
    );
  }

  FutureOr<void> _onFetchItems(
    FetchItemsEvent event,
    Emitter<ListState> emit,
  ) async {
    emit(ListLoadingState());
    await _itemsSubscription?.cancel();
    final result = await fetchItems(event.groupId);
    result.fold((failure) => emit(ListErrorState(message: failure.message)), (
      stream,
    ) {
      _itemsSubscription = stream.listen((items) => add(_ItemsUpdated(items)));
    });
  }

  FutureOr<void> _onDeleteItem(
    DeleteItemEvent event,
    Emitter<ListState> emit,
  ) async {
    final result = await deleteItem(
      DeleteItemParams(groupId: event.groupId, itemId: event.itemId),
    );

    result.fold((failure) => emit(ListErrorState(message: failure.message)), (
      _,
    ) {
      emit(ListDeletedState());
    });
  }

  FutureOr<void> _onEditItem(
    EditItemEvent event,
    Emitter<ListState> emit,
  ) async {
    final result = await editItem(
      EditItemParams(
        groupId: event.groupId,
        itemId: event.itemId,
        itemName: event.itemName,
        count: event.count,
        unit: event.unit,
      ),
    );

    result.fold(
      (failure) => emit(ListErrorState(message: failure.message)),
      (_) => emit(ListEditedState()),
    );
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }
}
