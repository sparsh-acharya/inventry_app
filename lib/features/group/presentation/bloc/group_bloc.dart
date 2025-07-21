import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/group/domain/entities/group_entity.dart';
import 'package:inventry_app/features/group/domain/usecases/add_user_to_group_usecase.dart';
import 'package:inventry_app/features/group/domain/usecases/create_group_usecase.dart';
import 'package:inventry_app/features/group/domain/usecases/delete_group_usecase.dart';
import 'package:inventry_app/features/group/domain/usecases/get_groups_usecase.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';
import 'package:inventry_app/features/user/domain/usecase/find_user_by_handle_usecase.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GetGroupsUsecase getGroups;
  final CreateGroupUsecase createGroup;
  final DeleteGroupUsecase deleteGroup;
  final FindUserByHandleUsecase findUserByHandle;
  final AddUserToGroupUsecase addUserToGroup;
  GroupBloc({
    required this.getGroups,
    required this.createGroup,
    required this.deleteGroup,
    required this.findUserByHandle,
    required this.addUserToGroup,
  }) : super(GroupInitialState()) {
    on<CreateGroupEvent>(_onCreateGroup);
    on<FetchGroupsEvent>(_onFetchGroup);
    on<DeleteGroupEvent>(_onDeleteGroup);
    on<SearchUserByHandleEvent>(_onSearchUser);
    on<AddUserToGroupEvent>(_onAddUserToGroup);
  }

  FutureOr<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoadingState());
    final result = await createGroup(
      CreateGroupParams(groupName: event.groupName, adminId: event.adminId),
    );
    result.fold((failure) => emit(GroupErrorState(message: failure.message)), (
      _,
    ) {
      emit(GroupcreatedState(name: event.groupName));
      add(FetchGroupsEvent(uid: event.adminId));
    });
  }

  FutureOr<void> _onFetchGroup(
    FetchGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoadingState());
    final result = await getGroups(event.uid);
    result.fold(
      (failure) => emit(GroupErrorState(message: failure.message)),
      (groups) => emit(GroupLoadedState(groups: groups)),
    );
  }

  FutureOr<void> _onDeleteGroup(
    DeleteGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupLoadingState());
    final result = await deleteGroup(
      DeleteGroupParams(groupId: event.groupId, adminId: event.adminId),
    );
    result.fold((failure) => emit(GroupErrorState(message: failure.message)), (
      _,
    ) {
      emit(GroupDeletedState());
      add(FetchGroupsEvent(uid: event.adminId));
    });
  }

  Future<void> _onSearchUser(
    SearchUserByHandleEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupSearchLoadingState());
    final result = await findUserByHandle(event.handle);

    result.fold((failure) => emit(GroupErrorState(message: failure.message)), (
      user,
    ) {
      if (user != null) {
        emit(UserFoundState(user: user));
      } else {
        emit(const GroupErrorState(message: 'User not found.'));
      }
    });
  }

  Future<void> _onAddUserToGroup(
    AddUserToGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    // We don't need a loading state here, to avoid UI jumps
    final result = await addUserToGroup(
      AddUserToGroupParams(groupId: event.groupId, userId: event.userId),
    );

    result.fold(
      (failure) => emit(GroupErrorState(message: failure.message)),
      (_) => emit(UserAddedToGroupState()),
    );
  }
}
