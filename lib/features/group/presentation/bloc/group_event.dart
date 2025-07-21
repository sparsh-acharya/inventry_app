part of 'group_bloc.dart';

sealed class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class FetchGroupsEvent extends GroupEvent {
  final String uid;

  const FetchGroupsEvent({required this.uid});

  @override
  List<Object> get props => [uid];
}

class CreateGroupEvent extends GroupEvent {
  final String groupName;
  final String adminId;

  const CreateGroupEvent({required this.groupName, required this.adminId});

  @override
  List<Object> get props => [groupName, adminId];
}

class DeleteGroupEvent extends GroupEvent {
  final String groupId;
  final String adminId;

  const DeleteGroupEvent({required this.groupId, required this.adminId});

  @override
  List<Object> get props => [groupId, adminId];
}

class SearchUserByHandleEvent extends GroupEvent {
  final String handle;

  const SearchUserByHandleEvent({required this.handle});

  @override
  List<Object> get props => [handle];
}


class AddUserToGroupEvent extends GroupEvent {
  final String groupId;
  final String userId;

  const AddUserToGroupEvent({required this.groupId, required this.userId});

  @override
  List<Object> get props => [groupId, userId];
}
