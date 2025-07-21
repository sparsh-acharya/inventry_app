part of 'group_bloc.dart';

sealed class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

final class GroupInitialState extends GroupState {}

final class GroupLoadingState extends GroupState {}

final class GroupLoadedState extends GroupState {
  final List<GroupEntity>? groups;

  const GroupLoadedState({required this.groups});

  @override
  List<Object> get props => [groups ?? []];
}

final class GroupcreatedState extends GroupState {
  final String name;

  const GroupcreatedState({required this.name});

  @override
  List<Object> get props => [name];
}

final class GroupErrorState extends GroupState {
  final String message;

  const GroupErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class GroupDeletedState extends GroupState {}

final class GroupSearchLoadingState extends GroupState {}

final class UserFoundState extends GroupState {
  final UserEntity user;

  const UserFoundState({required this.user});

  @override
  List<Object> get props => [user];
}

final class UserAddedToGroupState extends GroupState {}
