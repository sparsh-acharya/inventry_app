part of 'list_bloc.dart';

sealed class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

final class ListInitialState extends ListState {}

final class ListLoadingState extends ListState {}

final class ListLoadedState extends ListState {
  final List<ListEntity>? items;

  const ListLoadedState({required this.items});
  @override
  List<Object> get props => [items ?? []];
}

final class ListAddedState extends ListState {
  final String name;

  const ListAddedState({required this.name});

  @override
  List<Object> get props => [name];
}

final class ListErrorState extends ListState {
  final String message;

  const ListErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ListDeletedState extends ListState {}
final class ListEditedState extends ListState {}
