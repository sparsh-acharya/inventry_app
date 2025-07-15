import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventry_app/core/usecase/usecase.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';
import 'package:inventry_app/features/user/domain/usecase/get_currentuser_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/is_new_user_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/set_displayname_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/set_user_in_firestore_usecase.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCurrentuserUsecase getCurrentUser;
  final SetDisplaynameUsecase setDisplayName;
  final IsNewUserUsecase isNewUser;
  final SetUserInFirestoreUsecase setUserInFirestore;

  UserEntity? _userCache;

  UserBloc({
    required this.isNewUser,
    required this.getCurrentUser,
    required this.setDisplayName,
    required this.setUserInFirestore,
  }) : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<UpdateDisplayNameEvent>(_onUpdateDisplayName);
    on<IsNewUserEvent>(_onIsNewUser);
    on<CreateUserInFirestoreEvent>(_onCreateUserInFirestore);
  }

  void _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await getCurrentUser(NoParams());
    result.fold(
      (failure) => emit(const UserError("could not fetch the user")),
      (user) {
        if (user != null) {
          _userCache = user;
          emit(UserLoaded(user));
        } else {
          emit(const UserError("No user found"));
        }
      },
    );
  }

  Future<void> _onUpdateDisplayName(
    UpdateDisplayNameEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    final result = await setDisplayName(event.newName);
    result.fold((failure) => emit(UserError(failure.message)), (_) {
      if (_userCache != null) {
        _userCache = _userCache!.copyWith(displayName: event.newName);
        emit(UserUpdated("Display name updated"));
        emit(UserLoaded(_userCache!));
      }
    });
  }

  FutureOr<void> _onIsNewUser(
    IsNewUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await isNewUser(event.uid);
    result.fold((failure) => emit(UserError(failure.message)), (check) {
      if (check) {
        emit(NewUserState(uid: event.uid));
      } else if (_userCache != null) {
        emit(UserLoaded(_userCache!));
      } else {
        emit(UserError('no user found'));
      }
    });
  }

  Future<void> _onCreateUserInFirestore(
    CreateUserInFirestoreEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await setUserInFirestore(
      SetUserInFirestoreParams(
        uid: event.uid,
        phone: event.phone,
        displayName: event.displayName,
      ),
    );
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (_) => emit(UserCreatedInFirestore('User created in Firestore')),
    );
  }
}
