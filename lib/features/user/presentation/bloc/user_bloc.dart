import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventry_app/core/utils/usecase.dart';
import 'package:inventry_app/features/user/domain/entity/avatar_entity.dart';
import 'package:inventry_app/features/user/domain/entity/user_entity.dart';
import 'package:inventry_app/features/user/domain/usecase/clain_handle_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/get_avatars_isecase.dart';
import 'package:inventry_app/features/user/domain/usecase/get_currentuser_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/is_new_user_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/request_fcm_token_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/save_fcm_token_usecase.dart';
import 'package:inventry_app/features/user/domain/usecase/set_displayname_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCurrentuserUsecase getCurrentUser;
  final SetDisplaynameUsecase setDisplayName;
  final IsNewUserUsecase isNewUser;
  final ClaimHandleUsecase claimUserHandle;
  final GetAvatarsUsecase getAvatars;
  final RequestFCMTokenUsecase requestFCMToken;
  final SaveFCMTokenUsecase saveFCMToken;

  UserEntity? _userCache;

  UserBloc({
    required this.isNewUser,
    required this.getCurrentUser,
    required this.setDisplayName,
    required this.claimUserHandle,
    required this.getAvatars,
    required this.requestFCMToken,
    required this.saveFCMToken,
  }) : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<UpdateDisplayNameEvent>(_onUpdateDisplayName);
    on<IsNewUserEvent>(_onIsNewUser);
    on<CreateUserInFirestoreEvent>(_onCreateUserInFirestore);
    on<FetchAvatarsEvent>(_onFetchAvatars);
    on<RequestFCMTokenEvent>(_onRequestToken);
    on<SaveFCMTokenEvent>(_onSaveFcm);
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
        add(FetchAvatarsEvent());
      } else {
        add(LoadUserEvent());
      }
    });
  }

  Future<void> _onCreateUserInFirestore(
    CreateUserInFirestoreEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await claimUserHandle(
      ClaimHandleParams(
        uid: event.uid,
        handle: event.userHandle,
        displayName: event.displayName,
        phone: event.phone,
        avatarUrl: event.avatarUrl,
      ),
    );

    result.fold(
      (failure) => emit(UserError(failure.message)),
      (_) => add(LoadUserEvent()),
    );
  }

  Future<void> _onFetchAvatars(
    FetchAvatarsEvent event,
    Emitter<UserState> emit,
  ) async {
    // emit(AvatarsLoading());
    final result = await getAvatars(const NoParams());
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (avatars) => emit(AvatarsLoaded(avatars: avatars)),
    );
  }

  FutureOr<void> _onRequestToken(
    RequestFCMTokenEvent event,
    Emitter<UserState> emit,
  ) async {
    final result = await requestFCMToken(NoParams());
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (token) {
        if (token != null) {
          add(SaveFCMTokenEvent(token));
        } else {
          emit(const UserError("FCM token is null"));
        }
      },
    );
  }

  FutureOr<void> _onSaveFcm(SaveFCMTokenEvent event, Emitter<UserState> emit) async{
    final result = await saveFCMToken(event.token);
    result.fold((failure)=> emit(UserError(failure.message)), (_) {});
  }
}
