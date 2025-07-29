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

final class GroupMembersLoadingState extends GroupState {}

final class GroupMembersLoadedState extends GroupState {
  final List<UserEntity> members;

  const GroupMembersLoadedState({required this.members});

  @override
  List<Object> get props => [members];
}

final class UserRemovedFromGroupState extends GroupState {}

final class GroupNameUpdatedState extends GroupState {
  final String newName;

  const GroupNameUpdatedState({required this.newName});

  @override
  List<Object> get props => [newName];
}
